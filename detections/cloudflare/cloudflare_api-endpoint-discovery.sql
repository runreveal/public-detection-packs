SELECT
    clientIP,
    clientRequestHost,
    count(*) AS api_probe_count,
    count(DISTINCT clientRequestURI) AS unique_api_paths,
    countIf(edgeResponseStatus >= 400 AND edgeResponseStatus < 500) AS client_errors,
    groupArray(clientRequestURI) AS sample_paths,
    groupArray(edgeResponseStatus) AS sample_status_codes,
    min(receivedAt) AS first_seen,
    max(receivedAt) AS last_seen
FROM cf_http_logs
WHERE
    receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
    AND (clientRequestURI LIKE '%/api/%' OR clientRequestURI LIKE '%/v1/%' OR clientRequestURI LIKE '%/v2/%')
GROUP BY
    clientIP,
    clientRequestHost
HAVING
    unique_api_paths >= {threshold:UInt32}
    AND dateDiff('minute', first_seen, last_seen) <= {window:UInt32}
    AND client_errors > (api_probe_count * 0.3)
ORDER BY
    unique_api_paths DESC
