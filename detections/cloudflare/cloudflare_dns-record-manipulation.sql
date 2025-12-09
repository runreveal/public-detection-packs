SELECT
    actorEmail,
    srcIP,
    count(*) AS dns_change_count,
    groupArray(eventName) AS event_names,
    min(receivedAt) AS first_change,
    max(receivedAt) AS last_change
FROM cf_audit_logs
WHERE
    receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
    AND (
        eventName LIKE '%dns%record%create%'
        OR eventName LIKE '%dns%record%update%'
        OR eventName LIKE '%dns%record%delete%'
        OR eventName LIKE '%zone%setting%'
    )
GROUP BY
    actorEmail,
    srcIP
HAVING
    dns_change_count >= {threshold:UInt32}
    AND dateDiff('minute', first_change, last_change) <= {window:UInt32}
ORDER BY
    dns_change_count DESC
