-- UEBA per-actor behavioral anomaly. Reads the ueba_actor_hourly materialized
-- view (not raw logs): scores the most-recently-settled hour against each
-- actor's own trailing 30-day baseline. {from}/{to} are the scheduler window;
-- the settled hour lags ~1h so late-arriving data is not missed.
WITH
  base AS (
    SELECT principal, sourceType,
      median(events) AS medHourly,
      quantileExact(0.75)(events) - quantileExact(0.25)(events) AS iqrHourly,
      groupUniqArrayArray(countries)  AS baseCountries,
      groupUniqArrayArray(asns)       AS baseASNs,
      groupUniqArrayArray(eventNames) AS baseEventNames,
      groupUniqArrayArray(resources)  AS baseResources,
      groupUniqArray(toUInt16((toDayOfWeek(hourBucket) - 1) * 24 + toHour(hourBucket))) AS baseHours,
      count() AS baseHourSamples
    FROM runreveal.ueba_actor_hourly
    WHERE hourBucket >= toStartOfHour({from:DateTime}) - INTERVAL 1 HOUR - INTERVAL 30 DAY
      AND hourBucket <  toStartOfHour({from:DateTime}) - INTERVAL 1 HOUR
    GROUP BY principal, sourceType
  ),
  cur AS (
    SELECT principal, sourceType,
      sum(events) AS curEvents,
      groupUniqArrayArray(countries)  AS curCountries,
      groupUniqArrayArray(asns)       AS curASNs,
      groupUniqArrayArray(eventNames) AS curEventNames,
      groupUniqArrayArray(resources)  AS curResources,
      groupUniqArray(toUInt16((toDayOfWeek(hourBucket) - 1) * 24 + toHour(hourBucket))) AS curHours
    FROM runreveal.ueba_actor_hourly
    WHERE hourBucket >= toStartOfHour({from:DateTime}) - INTERVAL 1 HOUR
      AND hourBucket <  toStartOfHour({to:DateTime}) - INTERVAL 1 HOUR
      AND principal LIKE '%@%' AND principal NOT LIKE '%.internal'
      AND sourceType != 'runreveal-audit'
    GROUP BY principal, sourceType
  ),
  prev AS (
    SELECT principal, sourceType, sum(events) AS prevEvents
    FROM runreveal.ueba_actor_hourly
    WHERE hourBucket >= toStartOfHour({from:DateTime}) - INTERVAL 2 HOUR
      AND hourBucket <  toStartOfHour({from:DateTime}) - INTERVAL 1 HOUR
      AND sourceType != 'runreveal-audit'
    GROUP BY principal, sourceType
  ),
  scored AS (
    SELECT c.principal AS principal, c.sourceType AS sourceType, c.curEvents AS curEvents,
      b.medHourly AS medHourly, b.iqrHourly AS iqrHourly, b.baseHourSamples AS baseHourSamples,
      coalesce(p.prevEvents, 0) AS prevEvents,
      b.medHourly + 3 * greatest(1, b.iqrHourly * 1.5) AS volThreshold,
      arrayFilter(x -> NOT has(b.baseCountries, x),  c.curCountries)  AS newCountries,
      arrayFilter(x -> NOT has(b.baseASNs, x),       c.curASNs)       AS newASNs,
      arrayFilter(x -> NOT has(b.baseEventNames, x), c.curEventNames) AS newEventNames,
      arrayFilter(x -> NOT has(b.baseResources, x),  c.curResources)  AS newResources,
      arrayFilter(x -> NOT has(b.baseHours, x),      c.curHours)      AS newHours
    FROM cur AS c INNER JOIN base AS b USING (principal, sourceType)
    LEFT JOIN prev AS p USING (principal, sourceType)
  ),
  sharedCountries AS (
    SELECT arrayDistinct(groupArray(v)) AS vals FROM (
      SELECT v, uniqExact(principal) AS np FROM (SELECT principal, arrayJoin(newCountries) AS v FROM scored)
      GROUP BY v HAVING np >= 3)
  ),
  sharedASNs AS (
    SELECT arrayDistinct(groupArray(v)) AS vals FROM (
      SELECT v, uniqExact(principal) AS np FROM (SELECT principal, arrayJoin(newASNs) AS v FROM scored)
      GROUP BY v HAVING np >= 3)
  ),
  sharedResources AS (
    SELECT arrayDistinct(groupArray(v)) AS vals FROM (
      SELECT v, uniqExact(principal) AS np FROM (SELECT principal, arrayJoin(newResources) AS v FROM scored)
      GROUP BY v HAVING np >= 3)
  ),
  flags AS (
    SELECT s.*,
      arrayFilter(x -> NOT has(sc.vals, x), s.newCountries) AS effNewCountries,
      arrayFilter(x -> NOT has(sa.vals, x), s.newASNs)      AS effNewASNs,
      arrayFilter(x -> NOT has(sr.vals, x), s.newResources) AS effNewResources
    FROM scored s
      CROSS JOIN sharedCountries sc
      CROSS JOIN sharedASNs sa
      CROSS JOIN sharedResources sr
  )
SELECT
  principal,
  sourceType,
  curEvents AS events,
  round(medHourly, 1) AS baselineMedianHourly,
  round((curEvents - medHourly) / greatest(1, iqrHourly * 1.5), 2) AS volumeScore,
  arrayFilter(r -> r != '', [
    if(baseHourSamples >= 24 AND curEvents >= 20 AND curEvents > volThreshold AND prevEvents <= volThreshold,
       concat('volume spike: ', toString(curEvents), ' events vs ~', toString(round(medHourly, 1)), '/hr baseline'), ''),
    if(notEmpty(effNewCountries), concat('new country: ', arrayStringConcat(effNewCountries, ', ')), ''),
    if(notEmpty(effNewASNs) AND ((baseHourSamples >= 24 AND curEvents >= 20 AND curEvents > volThreshold AND prevEvents <= volThreshold) OR notEmpty(effNewCountries) OR (baseHourSamples >= 48 AND notEmpty(newEventNames))),
       concat('new network/ASN: ', arrayStringConcat(arrayMap(x -> toString(x), effNewASNs), ', ')), ''),
    if(baseHourSamples >= 48 AND notEmpty(newEventNames),
       concat('first-seen actions: ', arrayStringConcat(arraySlice(newEventNames, 1, 5), ', ')), ''),
    if(baseHourSamples >= 48 AND notEmpty(effNewResources),
       concat('first-seen resources: ', arrayStringConcat(arraySlice(effNewResources, 1, 3), ', ')), ''),
    if(baseHourSamples >= 72 AND curEvents >= 10 AND notEmpty(newHours),
       'activity in never-before-seen hour-of-week', '')
  ]) AS reasons
FROM flags
WHERE notEmpty(reasons)
ORDER BY volumeScore DESC
;
