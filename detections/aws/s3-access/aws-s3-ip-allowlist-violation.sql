SELECT
    remoteIP,
    requester,
    bucket,
    operation,
    COUNT(*) AS access_count,
    groupArray(key) AS accessed_objects,
    MIN(receivedAt) AS first_access,
    MAX(receivedAt) AS last_access,
    MAX(receivedAt) AS receivedAt
FROM s3_access_logs
WHERE
    (receivedAt >= {from:DateTime})
    AND (receivedAt <= {to:DateTime})
    AND httpStatus = '200'
    AND operation IN ('REST.GET.OBJECT', 'REST.PUT.OBJECT', 'REST.DELETE.OBJECT')
    AND NOT has({allowedIPs:Array(String)}, remoteIP)
GROUP BY
    remoteIP,
    requester,
    bucket,
    operation
ORDER BY access_count DESC
