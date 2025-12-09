SELECT
    `actor.email`,
    `actor.profileID`,
    count(*) as query_count,
    groupArray(DISTINCT eventName) as event_types,
    min(eventTime) as first_event,
    max(eventTime) as last_event
FROM gsuite_logs
WHERE
    `id.applicationName` = 'admin'
    AND eventName LIKE '%USER%'
    AND (receivedAt >= {from:DateTime})
    AND (receivedAt <= {to:DateTime})
GROUP BY
    `actor.email`,
    `actor.profileID`
HAVING count(*) >= {threshold:UInt32}
;
