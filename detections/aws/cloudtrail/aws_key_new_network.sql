WITH arns_and_events AS
    (
        SELECT DISTINCT
            `userIdentity.accessKeyId` AS accessKeyId,
            groupUniqArray(srcASNumber) AS srcASNumbers
        FROM aws_cloudtrail_logs
        WHERE ((receivedAt >= ({from:DateTime} - toIntervalDay({window:UInt32}))) AND (receivedAt <= {from:DateTime})) AND (accessKeyId LIKE 'AKIA%')
        GROUP BY accessKeyId
    )
SELECT
    `userIdentity.accessKeyId` AS accessKeyId,
    `userIdentity.userName`,
    srcIP,
    srcASNumber,
    srcASOrganization,
    groupUniqArrayArray(resources)
FROM aws_cloudtrail_logs
LEFT JOIN arns_and_events ON arns_and_events.accessKeyId = accessKeyId
WHERE ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime})) AND (eventName != '') AND (NOT has({ignoreNetworksByAS:Array(UInt32)}, srcASNumber)) AND (accessKeyId LIKE 'AKIA%') AND (NOT has(arns_and_events.srcASNumbers, srcASNumber)) AND (NOT has({ignoreIPs:Array(String)}, srcIP))
GROUP BY
    accessKeyId,
    `userIdentity.userName`,
    srcIP,
    srcASNumber,
    srcASOrganization
;

