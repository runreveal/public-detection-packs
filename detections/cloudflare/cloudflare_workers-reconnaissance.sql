SELECT
    clientIP,
    clientRequestHost,
    count(*) AS worker_probe_count,
    count(DISTINCT clientRequestURI) AS unique_worker_paths,
    countIf(edgeResponseStatus = 404) AS not_found_count,
    groupArray(clientRequestURI) AS sample_paths,
    min(receivedAt) AS first_seen,
    max(receivedAt) AS last_seen
FROM cf_http_logs
WHERE
    receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
    AND (
        clientRequestURI LIKE '%/worker%'
        OR clientRequestURI LIKE '%/cdn-cgi/%'
        OR clientRequestURI LIKE '%/.well-known/%'
    )
GROUP BY
    clientIP,
    clientRequestHost
HAVING
    unique_worker_paths >= {threshold:UInt32}
    AND dateDiff('minute', first_seen, last_seen) <= {window:UInt32}
    AND not_found_count > (worker_probe_count * 0.5)
ORDER BY
    unique_worker_paths DESC
