WITH countryVisit AS
    (
        SELECT DISTINCT
            user_email,
            groupUniqArray(srcASCountryCode) AS countrys
        FROM auth0_logs
        WHERE (receivedAt >= ({from:DateTime} - toIntervalDay(30))) AND (receivedAt <= {from:DateTime})
        GROUP BY user_email
    )
SELECT
    user_email,
    user_id,
    srcASCountryCode,
    srcIP,
    countrys AS previousVisits,
    count(*) AS eventCount,
    groupArray(type) AS eventTypes
FROM auth0_logs
LEFT JOIN countryVisit ON countryVisit.user_email = auth0_logs.user_email
WHERE (auth0_logs.receivedAt >= {from:DateTime})
  AND (auth0_logs.receivedAt <= {to:DateTime})
  AND (auth0_logs.srcASCountryCode IS NOT NULL)
  AND (auth0_logs.srcASCountryCode != '')
  AND (countryVisit.user_email != '')
  AND (NOT has(countryVisit.countrys, auth0_logs.srcASCountryCode))
GROUP BY
    user_email,
    user_id,
    srcASCountryCode,
    srcIP,
    countrys
ORDER BY
    eventCount DESC,
    user_email ASC;
