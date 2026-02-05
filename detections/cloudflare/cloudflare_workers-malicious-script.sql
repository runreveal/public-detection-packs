SELECT
    actorEmail,
    srcIP,
    count(*) AS script_upload_count,
    groupArray(eventName) AS event_names,
    min(receivedAt) AS first_upload,
    max(receivedAt) AS last_upload
FROM cf_audit_logs
WHERE
    receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
    AND (
        eventName LIKE '%worker%upload%'
        OR eventName LIKE '%worker%update%'
        OR eventName LIKE '%worker%script%'
    )
GROUP BY
    actorEmail,
    srcIP
HAVING
    script_upload_count >= 1
ORDER BY
    first_upload DESC
