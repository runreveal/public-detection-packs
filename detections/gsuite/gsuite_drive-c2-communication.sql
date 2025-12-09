SELECT
    `actor.email`,
    count(*) as file_operations,
    count(DISTINCT eventName) as operation_types,
    groupArray(DISTINCT eventName) as operations,
    min(eventTime) as first_event,
    max(eventTime) as last_event,
    dateDiff('second', min(eventTime), max(eventTime)) as duration_seconds
FROM gsuite_logs
WHERE
    `id.applicationName` = 'drive'
    AND eventName IN ('edit', 'upload', 'download', 'access_url')
    AND (receivedAt >= {from:DateTime})
    AND (receivedAt <= {to:DateTime})
GROUP BY
    `actor.email`
HAVING count(*) >= {threshold:UInt32} AND duration_seconds < 3600
;
