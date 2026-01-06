SELECT
    `actor.email`,
    `actor.uuid`,
    count(*) as reveal_count,
    count(DISTINCT `usage.item`) as unique_items,
    count(DISTINCT `usage.vault`) as unique_vaults,
    min(eventTime) as first_event,
    max(eventTime) as last_event
FROM one_password_logs
WHERE
    eventName = 'reveal'
    AND (receivedAt >= {from:DateTime})
    AND (receivedAt <= {to:DateTime})
GROUP BY
    `actor.email`,
    `actor.uuid`
HAVING count(*) >= {threshold:UInt32}
;
