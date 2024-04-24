WITH countryVisit AS
    (
        SELECT DISTINCT
            `actor.alternateID` AS user,
            groupUniqArray(srcASCountryCode) AS countrys
        FROM okta_logs
        WHERE (eventTime >= ({from:DateTime} - toIntervalDay(30))) AND (eventTime <= {from:DateTime})
        GROUP BY user
    )
SELECT
    `actor.alternateID` AS user,
    srcASCountryCode,
    countrys AS previousVisits,
    count(*) AS eventCount
FROM okta_logs
LEFT JOIN countryVisit ON countryVisit.user = user
WHERE ((okta_logs.receivedAt >= {from:DateTime}) AND (okta_logs.receivedAt <= {to:DateTime})) AND (okta_logs.srcASCountryCode IS NOT NULL) AND (`actor.type` = 'User') AND (countryVisit.user != '') AND (NOT has(countryVisit.countrys, okta_logs.srcASCountryCode))
GROUP BY
    user,
    srcASCountryCode,
    countryVisit.user,
    countrys
ORDER BY
    eventCount DESC,
    user ASC,
    srcASCountryCode ASC
;

