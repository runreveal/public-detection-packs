SELECT
    actor['alternateId'] AS user_email,
    client['ipAddress'] AS source_ip,
    count(*) AS group_query_count,
    count(DISTINCT target) AS unique_groups
FROM
    runreveal.logs
WHERE
    sourceType = 'okta'
    AND (eventName LIKE '%group%' AND (eventName LIKE '%read%' OR eventName LIKE '%list%'))
    AND receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
GROUP BY
    user_email,
    source_ip
HAVING
    group_query_count >= {threshold:UInt32}
