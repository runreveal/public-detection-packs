SELECT
    clientIP,
    clientRequestHost,
    count(*) AS dns_query_count,
    count(DISTINCT clientRequestURI) AS unique_paths,
    groupArray(clientRequestURI) AS sample_paths,
    min(receivedAt) AS first_seen,
    max(receivedAt) AS last_seen
FROM cf_http_logs
WHERE
    receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
    AND clientRequestHost != ''
GROUP BY
    clientIP,
    clientRequestHost
HAVING
    dns_query_count >= {threshold:UInt32}
    AND dateDiff('minute', first_seen, last_seen) <= {window:UInt32}
ORDER BY
    dns_query_count DESC
