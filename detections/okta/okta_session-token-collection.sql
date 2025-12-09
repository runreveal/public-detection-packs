SELECT
    actor['alternateId'] AS user_email,
    client['ipAddress'] AS source_ip,
    count(*) AS session_event_count,
    count(DISTINCT sessionId) AS unique_sessions
FROM
    runreveal.logs
WHERE
    sourceType = 'okta'
    AND (eventName LIKE '%session%' OR eventName LIKE '%token%')
    AND (eventName LIKE '%create%' OR eventName LIKE '%refresh%' OR eventName LIKE '%validate%')
    AND receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
GROUP BY
    user_email,
    source_ip
HAVING
    session_event_count >= {threshold:UInt32}
