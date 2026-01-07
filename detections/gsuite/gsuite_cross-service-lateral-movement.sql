SELECT
    `actor.email`,
    count(DISTINCT `id.applicationName`) as services_accessed,
    groupArray(DISTINCT `id.applicationName`) as services,
    count(*) as total_events,
    min(eventTime) as first_event,
    max(eventTime) as last_event
FROM gsuite_logs
WHERE
    (receivedAt >= {from:DateTime})
    AND (receivedAt <= {to:DateTime})
GROUP BY
    `actor.email`
HAVING count(DISTINCT `id.applicationName`) >= {threshold:UInt32}
;
