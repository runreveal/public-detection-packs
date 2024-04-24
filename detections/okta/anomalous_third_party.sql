WITH eventTypesCalled AS
    (
        SELECT DISTINCT
            `actor.displayName` AS user,
            groupUniqArray(eventType) AS eventTypes
        FROM okta_logs
        WHERE ((eventTime >= ({from:DateTime} - toIntervalDay({window:UInt32}))) AND (eventTime <= {from:DateTime})) AND (actor.type = 'PublicClientApp')
        GROUP BY user
    )
SELECT
    map('name', actor.displayName) AS actor,
    `actor.displayName` AS user,
    eventType,
    srcIP,
    eventTypes AS previousVisits,
    count(*) AS eventCount
FROM okta_logs
LEFT JOIN eventTypesCalled ON eventTypesCalled.user = user
WHERE ((okta_logs.receivedAt >= {from:DateTime}) AND (okta_logs.receivedAt <= {to:DateTime})) AND (actor.type = 'PublicClientApp') AND (okta_logs.eventType IS NOT NULL) AND (eventTypesCalled.user != '') AND (NOT has(eventTypesCalled.eventTypes, okta_logs.eventType))
GROUP BY
    user,
    eventType,
    eventTypesCalled.user,
    srcIP,
    eventTypes
ORDER BY
    eventCount DESC,
    user ASC,
    eventType ASC
;

