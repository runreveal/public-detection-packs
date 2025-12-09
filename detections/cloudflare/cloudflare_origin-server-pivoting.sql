SELECT
    clientIP,
    clientRequestHost,
    count(*) AS request_count,
    count(DISTINCT clientRequestURI) AS unique_paths,
    countIf(edgeResponseStatus >= 500) AS server_errors,
    countIf(edgeResponseStatus = 403) AS forbidden_count,
    groupArray(clientRequestURI) AS sample_paths,
    min(receivedAt) AS first_seen,
    max(receivedAt) AS last_seen
FROM cf_http_logs
WHERE
    receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
    AND (
        clientRequestURI LIKE '%/admin%'
        OR clientRequestURI LIKE '%/internal%'
        OR clientRequestURI LIKE '%/backend%'
        OR clientRequestURI LIKE '%origin%'
    )
GROUP BY
    clientIP,
    clientRequestHost
HAVING
    request_count >= {threshold:UInt32}
    AND dateDiff('minute', first_seen, last_seen) <= {window:UInt32}
    AND (server_errors > 0 OR forbidden_count > 10)
ORDER BY
    request_count DESC
