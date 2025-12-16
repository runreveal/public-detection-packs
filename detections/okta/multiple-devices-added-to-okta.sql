WITH mda AS
    (
        SELECT
            lower(actor['email']) AS actorEmail,
            count(*) AS c
        FROM runreveal.logs
        WHERE (sourceType = 'okta') AND (eventName = 'device.user.add') AND ((receivedAt >= {to:DateTime} - INTERVAL {interval:Int64} DAY) AND (receivedAt < {to:DateTime}))
        GROUP BY actorEmail
        HAVING c >= {deviceThreshold:Int64}
    )
SELECT
    mda.actorEmail,
    mda.c AS evtCount,
    eventTime,
    srcIP,
    srcASCountryCode,
    srcASNumber,
    srcASOrganization,
    srcCity,
    srcConnectionType,
    srcISP,
    actor,
    simpleJSONExtractRaw(rawLog, 'client') AS clientInfo
FROM runreveal.logs AS logs
INNER JOIN mda ON mda.actorEmail = lower(actor['email'])
WHERE (logs.sourceType = 'okta') AND (logs.eventName = 'device.user.add') AND ((receivedAt >= {from:DateTime}) AND (receivedAt < {to:DateTime}))
ORDER BY
    evtCount DESC,
    mda.actorEmail ASC