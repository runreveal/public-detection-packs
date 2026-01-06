SELECT
    actor['alternateId'] AS user_email,
    client['ipAddress'] AS source_ip,
    client['userAgent']['rawUserAgent'] AS user_agent,
    count(*) AS api_call_count,
    count(DISTINCT eventName) AS unique_event_types,
    min(receivedAt) AS first_seen,
    max(receivedAt) AS last_seen,
    dateDiff('second', min(receivedAt), max(receivedAt)) AS duration_seconds
FROM
    runreveal.logs
WHERE
    sourceType = 'okta'
    AND eventName LIKE '%api%'
    AND receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
GROUP BY
    user_email,
    source_ip,
    user_agent
HAVING
    api_call_count >= {threshold:UInt32}
    AND duration_seconds < 300
