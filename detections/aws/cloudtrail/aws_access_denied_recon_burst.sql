SELECT
    `userIdentity.arn`,
    any(`userIdentity.type`) AS identityType,
    any(`userIdentity.accountId`) AS accountId,
    groupUniqArray(5)(`userIdentity.userName`) AS userNames,
    groupUniqArray(5)(`userIdentity.accessKeyId`) AS accessKeyIds,
    uniqExact(eventName) AS denied_api_count,
    uniqExact(eventSource) AS denied_service_count,
    count() AS denied_event_count,
    groupUniqArray(25)(eventName) AS denied_apis,
    groupUniqArray(10)(eventSource) AS denied_services,
    groupUniqArray(10)(srcIP) AS src_ips,
    groupUniqArray(5)(userAgent) AS user_agents,
    groupUniqArray(5)(awsRegion) AS regions,
    min(eventTime) AS first_event,
    max(eventTime) AS last_event
FROM aws_cloudtrail_logs
WHERE (receivedAt > {from:DateTime})
    AND (receivedAt < {to:DateTime})
    AND errorCode IN ('AccessDenied', 'AccessDeniedException', 'UnauthorizedOperation', 'Client.UnauthorizedOperation')
GROUP BY `userIdentity.arn`
HAVING uniqExact(eventName) >= {threshold:UInt32}
ORDER BY denied_api_count DESC
