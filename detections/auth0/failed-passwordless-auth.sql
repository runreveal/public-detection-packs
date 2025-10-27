SELECT
    user_email,
    srcIP,
    srcASCountryCode,
    count(*) AS failed_attempts,
    groupArray(type) AS event_types,
    groupArray(description) AS descriptions,
    min(receivedAt) AS first_attempt,
    max(receivedAt) AS last_attempt
FROM auth0_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime})
  AND type IN ('fdeaz', 'fdeac', 'feccft')
GROUP BY
    user_email,
    srcIP,
    srcASCountryCode
HAVING failed_attempts >= {threshold:UInt32}
ORDER BY failed_attempts DESC;
