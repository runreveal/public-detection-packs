SELECT
    `userIdentity.userName`,
    `userIdentity.arn`,
    awsRegion,
    count(*) as resource_count,
    groupArray(eventName) as events,
    min(eventTime) as first_event,
    max(eventTime) as last_event
FROM aws_cloudtrail_logs
WHERE
    eventName IN (
        'CreateVpc',
        'CreateSubnet',
        'CreateNatGateway',
        'CreateInternetGateway',
        'CreateRouteTable',
        'CreateNetworkAcl'
    )
    AND errorCode = ''
    AND (receivedAt >= {from:DateTime})
    AND (receivedAt <= {to:DateTime})
GROUP BY
    `userIdentity.userName`,
    `userIdentity.arn`,
    awsRegion
HAVING count(*) >= {threshold:UInt32}
;
