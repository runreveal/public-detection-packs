WITH networkVisit AS
    (
        SELECT DISTINCT
            `actor.alternateID` AS user,
            groupUniqArray(srcASOrganization) AS asorgs
        FROM okta_logs
        WHERE (receivedAt >= ({from:DateTime} - toIntervalDay({window:UInt32}))) AND (receivedAt <= {from:DateTime})
        GROUP BY user
    )
SELECT
    map('email', actor.alternateID) AS actor,
    `actor.alternateID` AS user,
    srcASOrganization,
    srcIP,
    asorgs AS previousVisits,
    count(*) AS eventCount
FROM okta_logs
LEFT JOIN networkVisit ON networkVisit.user = user
WHERE ((okta_logs.receivedAt >= {from:DateTime}) AND (okta_logs.receivedAt <= {to:DateTime})) AND (`actor.type` = 'User') AND (okta_logs.srcASOrganization IS NOT NULL) AND (NOT has({ignoreNetworksByAS:Array(UInt32)}, okta_logs.srcASNumber)) AND (networkVisit.user != '') AND (NOT has(networkVisit.asorgs, okta_logs.srcASOrganization))
GROUP BY
    user,
    srcASOrganization,
    networkVisit.user,
    asorgs,
    srcIP
ORDER BY
    eventCount DESC,
    user ASC,
    srcASOrganization ASC
;

