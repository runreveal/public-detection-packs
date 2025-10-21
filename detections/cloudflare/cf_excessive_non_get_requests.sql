SELECT
    clientIP,
    clientRequestMethod,
    count(*) AS request_count,
    groupArray(clientRequestURI) AS sample_uris,
    groupArray(edgeResponseStatus) AS sample_status_codes
FROM cf_http_logs
WHERE
    (receivedAt > {from:DateTime})
    AND (receivedAt < {to:DateTime})
    AND clientRequestMethod != {excluded_method:String}
GROUP BY
    clientIP,
    clientRequestMethod
HAVING
    request_count > {threshold:UInt32}
ORDER BY
    request_count DESC;
