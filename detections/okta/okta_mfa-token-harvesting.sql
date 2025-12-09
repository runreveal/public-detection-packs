SELECT
    actor['alternateId'] AS user_email,
    client['ipAddress'] AS source_ip,
    count(*) AS mfa_challenge_count,
    countIf(simpleJSONExtractString(simpleJSONExtractRaw(rawLog, 'outcome'), 'result') = 'FAILURE') AS failed_attempts,
    countIf(simpleJSONExtractString(simpleJSONExtractRaw(rawLog, 'outcome'), 'result') = 'SUCCESS') AS successful_attempts
FROM
    runreveal.logs
WHERE
    sourceType = 'okta'
    AND (eventName LIKE '%mfa%' OR eventName LIKE '%factor%')
    AND eventName LIKE '%challenge%'
    AND receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
GROUP BY
    user_email,
    source_ip
HAVING
    mfa_challenge_count >= {threshold:UInt32}
