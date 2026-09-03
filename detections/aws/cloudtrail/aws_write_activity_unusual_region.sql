WITH baseline AS (
    SELECT DISTINCT
        awsRegion,
        eventName
    FROM aws_cloudtrail_logs
    WHERE (receivedAt >= ({from:DateTime} - toIntervalDay({window:UInt32})))
        AND (receivedAt < {from:DateTime})
        AND (readOnly = false)
)
SELECT
    recent.awsRegion,
    recent.eventName,
    recent.eventSource,
    recent.`userIdentity.arn`,
    recent.`userIdentity.type`,
    recent.`userIdentity.userName`,
    recent.`userIdentity.accountId`,
    recent.`userIdentity.accessKeyId`,
    recent.srcIP,
    recent.srcASCountryCode,
    recent.srcASOrganization,
    recent.userAgent,
    recent.requestParameters,
    recent.eventTime,
    recent.eventID
FROM aws_cloudtrail_logs AS recent
LEFT ANTI JOIN baseline ON (baseline.awsRegion = recent.awsRegion) AND (baseline.eventName = recent.eventName)
WHERE (recent.receivedAt > {from:DateTime})
    AND (recent.receivedAt < {to:DateTime})
    AND (recent.readOnly = false)
    AND (recent.errorCode = '')
    AND (recent.`userIdentity.invokedBy` = '')
ORDER BY recent.eventTime ASC
