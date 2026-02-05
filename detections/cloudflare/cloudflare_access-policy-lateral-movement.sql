SELECT
    actorEmail,
    srcIP,
    count(*) AS policy_change_count,
    groupArray(eventName) AS event_names,
    min(receivedAt) AS first_change,
    max(receivedAt) AS last_change
FROM cf_audit_logs
WHERE
    receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
    AND (
        eventName LIKE '%access%policy%update%'
        OR eventName LIKE '%access%policy%create%'
        OR eventName LIKE '%access%group%'
        OR eventName LIKE '%access%application%'
    )
GROUP BY
    actorEmail,
    srcIP
HAVING
    policy_change_count >= {threshold:UInt32}
    AND dateDiff('minute', first_change, last_change) <= {window:UInt32}
ORDER BY
    policy_change_count DESC
