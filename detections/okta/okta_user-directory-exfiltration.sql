SELECT
    actor['alternateId'] AS user_email,
    client['ipAddress'] AS source_ip,
    client['userAgent']['rawUserAgent'] AS user_agent,
    count(*) AS directory_access_count,
    count(DISTINCT target) AS unique_users_accessed,
    min(receivedAt) AS first_seen,
    max(receivedAt) AS last_seen,
    dateDiff('second', min(receivedAt), max(receivedAt)) AS duration_seconds
FROM
    runreveal.logs
WHERE
    sourceType = 'okta'
    AND (eventName LIKE '%user%' OR eventName LIKE '%directory%')
    AND (eventName LIKE '%read%' OR eventName LIKE '%export%' OR eventName LIKE '%list%')
    AND receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
GROUP BY
    user_email,
    source_ip,
    user_agent
HAVING
    unique_users_accessed >= {threshold:UInt32}
