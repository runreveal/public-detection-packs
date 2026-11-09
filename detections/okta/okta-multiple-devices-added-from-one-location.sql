WITH mda AS
    (
        SELECT
            srcIP, count(*) AS c
        FROM runreveal.logs
        WHERE (sourceType = 'okta') AND (eventName = 'device.user.add') AND ((receivedAt >= {to:DateTime} - INTERVAL {interval:Int64} DAY) AND (receivedAt < {to:DateTime}))
        GROUP BY srcIP
        HAVING c > {deviceThreshold:Int64}
    )
SELECT
    mda.srcIP,
    mda.c AS evtCount,
    lower(actor['email']) AS actorEmail,
    eventTime,
    logs.srcIP,
    srcASCountryCode,
    srcASNumber,
    srcASOrganization,
    srcCity,
    srcConnectionType,
    srcISP,
    actor,
    simpleJSONExtractRaw(rawLog, 'client') AS clientInfo, simpleJSONExtractRaw(rawLog, 'device') as device
FROM runreveal.logs
INNER JOIN mda ON mda.srcIP = logs.srcIP
WHERE (logs.sourceType = 'okta') AND (logs.eventName = 'device.user.add') AND ((receivedAt >= {to:DateTime} - INTERVAL {interval:Int64} DAY) AND (receivedAt < {to:DateTime})) AND (isIPv4String(logs.srcIP) OR isIPv6String(logs.srcIP)) AND NOT arrayExists(c -> isIPAddressInRange(logs.srcIP, c), arrayFilter(c -> c != '', arrayMap(c -> trim(c), splitByChar(',', {officeCIDR:String}))))
ORDER BY
    evtCount DESC,
    mda.srcIP ASC