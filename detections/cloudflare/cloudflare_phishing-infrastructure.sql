SELECT
    actorEmail,
    eventName,
    srcIP,
    count(*) AS deployment_count,
    groupArray(resourceType) AS resource_types,
    min(receivedAt) AS first_deployment,
    max(receivedAt) AS last_deployment
FROM cf_audit_logs
WHERE
    receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
    AND (
        eventName LIKE '%pages%deploy%'
        OR eventName LIKE '%worker%create%'
        OR eventName LIKE '%worker%upload%'
    )
    AND (
        resourceType LIKE '%page%'
        OR resourceType LIKE '%worker%'
    )
GROUP BY
    actorEmail,
    eventName,
    srcIP
HAVING
    deployment_count >= 1
ORDER BY
    first_deployment DESC
