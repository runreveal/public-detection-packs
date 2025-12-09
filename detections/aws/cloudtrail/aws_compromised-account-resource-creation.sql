SELECT
    `userIdentity.userName`,
    `userIdentity.arn`,
    `userIdentity.accountId`,
    count(*) as creation_count,
    groupArray(DISTINCT eventName) as unique_events,
    groupArray(DISTINCT awsRegion) as regions,
    min(eventTime) as first_event,
    max(eventTime) as last_event
FROM aws_cloudtrail_logs
WHERE
    readOnly = false
    AND errorCode = ''
    AND eventName LIKE 'Create%'
    AND (receivedAt >= {from:DateTime})
    AND (receivedAt <= {to:DateTime})
GROUP BY
    `userIdentity.userName`,
    `userIdentity.arn`,
    `userIdentity.accountId`
HAVING count(*) >= {threshold:UInt32}
;
