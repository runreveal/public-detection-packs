SELECT
    actor['alternateId'] AS user_email,
    client['ipAddress'] AS source_ip,
    count(*) AS user_read_count,
    count(DISTINCT target) AS unique_users_accessed
FROM
    runreveal.logs
WHERE
    sourceType = 'okta'
    AND (eventName LIKE '%user%' AND eventName LIKE '%read%')
    AND receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
GROUP BY
    user_email,
    source_ip
HAVING
    unique_users_accessed >= {threshold:UInt32}
