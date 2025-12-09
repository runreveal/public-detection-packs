SELECT
    `actor.email`,
    count(*) as access_count,
    count(DISTINCT `id.applicationName`) as apps_accessed,
    groupArray(DISTINCT eventName) as event_types,
    min(eventTime) as first_event,
    max(eventTime) as last_event
FROM gsuite_logs
WHERE
    `id.applicationName` IN ('drive', 'calendar')
    AND eventName LIKE '%access%'
    AND (receivedAt >= {from:DateTime})
    AND (receivedAt <= {to:DateTime})
GROUP BY
    `actor.email`
HAVING count(*) >= {threshold:UInt32}
;
