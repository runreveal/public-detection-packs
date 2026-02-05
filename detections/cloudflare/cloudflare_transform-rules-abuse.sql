SELECT
    actorEmail,
    srcIP,
    count(*) AS transform_rule_count,
    groupArray(eventName) AS event_names,
    min(receivedAt) AS first_change,
    max(receivedAt) AS last_change
FROM cf_audit_logs
WHERE
    receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
    AND (
        eventName LIKE '%transform%rule%create%'
        OR eventName LIKE '%transform%rule%update%'
        OR eventName LIKE '%page%rule%create%'
        OR eventName LIKE '%page%rule%update%'
        OR eventName LIKE '%redirect%'
    )
GROUP BY
    actorEmail,
    srcIP
HAVING
    transform_rule_count >= {threshold:UInt32}
    AND dateDiff('minute', first_change, last_change) <= {window:UInt32}
ORDER BY
    transform_rule_count DESC
