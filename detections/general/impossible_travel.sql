SELECT
    *,
    concat(srcCity, ', ', srcASCountryCode) AS location,
    concat(prevCity, ', ', prevCC) AS prevLocation,
    round(geoDistance(srcLongitude, srcLatitude, prevLon, prevLat) / 1609, 2) AS distanceMi,
    round(age('second', prevTime, eventTime) / 3600, 2) AS timeDiff_Hours,
    round(distanceMi / timeDiff_Hours, 0) AS mph
FROM
(
    SELECT
        *,
        geohashEncode(srcLongitude, srcLatitude, 5) AS geoHash,
        countIf(eventTime < {from:DateTime}) OVER (PARTITION BY (actor['email'], geoHash)) AS visitCount,
        lagInFrame(srcASOrganization) OVER (PARTITION BY actor['email'] ORDER BY eventTime ASC) AS prevSrcAsOrg,
        lagInFrame(srcIP) OVER (PARTITION BY actor['email'] ORDER BY eventTime ASC) AS prevSrcIP,
        lagInFrame(srcLatitude) OVER (PARTITION BY actor['email'] ORDER BY eventTime ASC) AS prevLat,
        lagInFrame(srcLongitude) OVER (PARTITION BY actor['email'] ORDER BY eventTime ASC) AS prevLon,
        lagInFrame(eventTime) OVER (PARTITION BY actor['email'] ORDER BY eventTime ASC) AS prevTime,
        lagInFrame(srcASCountryCode) OVER (PARTITION BY actor['email'] ORDER BY eventTime ASC) AS prevCC,
        lagInFrame(srcCity) OVER (PARTITION BY actor['email'] ORDER BY eventTime ASC) AS prevCity,
        lagInFrame(sourceType) OVER (PARTITION BY actor['email'] ORDER BY eventTime ASC) AS prevSourceType
    FROM
    (
        SELECT *
        FROM runreveal.logs
        WHERE (
            nullIf(srcLatitude, 0) IS NOT NULL
        ) AND (
            nullIf(srcLongitude, 0) IS NOT NULL
        ) AND (
            receivedAt >= ({from:DateTime} - toIntervalHour(24))
        ) AND (
            sourceType NOT IN ['gsuite', 'flow']
        ) AND (
            NOT (
              (isIPv4String(srcIP) AND notEmpty(arrayFilter(x -> isIPAddressInRange(srcIP, x), {excludeV4CIDRs:Array(String)})))
              OR
              (isIPv6String(srcIP) AND notEmpty(arrayFilter(x -> isIPAddressInRange(srcIP, x), {excludeV6CIDRs:Array(String)})))
            )
        )
    )
)
WHERE (srcLatitude != prevLat) AND (srcLongitude != prevLon) AND (timeDiff_Hours > 0) AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime})) AND (prevSrcIP != srcIP) AND (srcASOrganization != prevSrcAsOrg) AND (mph > 767) AND (distanceMi > 250) AND (visitCount = 0)
ORDER BY
    mph DESC,
    eventTime DESC
;

