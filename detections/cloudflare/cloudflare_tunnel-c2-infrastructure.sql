SELECT
    actorEmail,
    eventName,
    srcIP,
    srcASOrganization,
    count(*) AS tunnel_creation_count,
    groupArray(resourceType) AS resource_types,
    min(receivedAt) AS first_seen,
    max(receivedAt) AS last_seen
FROM cf_audit_logs
WHERE
    receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
    AND (
        eventName LIKE '%tunnel%create%'
        OR eventName LIKE '%tunnel%route%'
        OR eventName LIKE '%argo%tunnel%'
    )
GROUP BY
    actorEmail,
    eventName,
    srcIP,
    srcASOrganization
HAVING
    tunnel_creation_count >= 1
ORDER BY
    first_seen DESC
