SELECT
    actor['alternateId'] AS user_email,
    client['ipAddress'] AS source_ip,
    count(*) AS group_access_count,
    count(DISTINCT target) AS unique_groups_accessed,
    min(receivedAt) AS first_seen,
    max(receivedAt) AS last_seen
FROM
    runreveal.logs
WHERE
    sourceType = 'okta'
    AND (eventName LIKE '%group%')
    AND (eventName LIKE '%read%' OR eventName LIKE '%export%' OR eventName LIKE '%list%' OR eventName LIKE '%member%')
    AND receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
GROUP BY
    user_email,
    source_ip
HAVING
    unique_groups_accessed >= {threshold:UInt32}
