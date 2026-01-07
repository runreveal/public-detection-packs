SELECT
    `actor.email`,
    count(*) as deletion_count,
    groupArray(DISTINCT `id.applicationName`) as affected_services,
    min(eventTime) as first_deletion,
    max(eventTime) as last_deletion
FROM gsuite_logs
WHERE
    eventName LIKE '%delete%' OR eventName LIKE '%remove%'
    AND (receivedAt >= {from:DateTime})
    AND (receivedAt <= {to:DateTime})
GROUP BY
    `actor.email`
HAVING count(*) >= {threshold:UInt32}
;
