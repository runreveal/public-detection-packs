SELECT
    `actor.email`,
    `actor.uuid`,
    count(*) as view_count,
    count(DISTINCT `usage.vault`) as unique_vaults,
    groupArray(DISTINCT `usage.vault`) as vaults_accessed,
    min(eventTime) as first_event,
    max(eventTime) as last_event
FROM one_password_logs
WHERE
    eventName = 'view'
    AND (receivedAt >= {from:DateTime})
    AND (receivedAt <= {to:DateTime})
GROUP BY
    `actor.email`,
    `actor.uuid`
HAVING count(DISTINCT `usage.vault`) >= {threshold:UInt32}
;
