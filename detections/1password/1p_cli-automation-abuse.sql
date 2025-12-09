SELECT
    `actor.email`,
    `actor.uuid`,
    `client.appName`,
    count(*) as event_count,
    count(DISTINCT `usage.item`) as unique_items,
    groupArray(eventName) as event_types,
    min(eventTime) as first_event,
    max(eventTime) as last_event
FROM one_password_logs
WHERE
    `client.appName` LIKE '%CLI%' OR `client.appName` LIKE '%cli%' OR `client.appName` = '1Password CLI'
    AND eventName IN ('reveal', 'server-fetch', 'secure-copy')
    AND (receivedAt >= {from:DateTime})
    AND (receivedAt <= {to:DateTime})
GROUP BY
    `actor.email`,
    `actor.uuid`,
    `client.appName`
HAVING count(*) >= {threshold:UInt32}
;
