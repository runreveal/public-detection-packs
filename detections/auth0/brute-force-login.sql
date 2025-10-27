SELECT
    user_email,
    srcIP,
    count(*) AS failedAttempts,
    groupArray(type) AS eventTypes,
    groupArray(description) AS descriptions,
    min(receivedAt) AS firstAttempt,
    max(receivedAt) AS lastAttempt
FROM auth0_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime})
  AND type IN ('f', 'fp', 'fu', 'limit_mu', 'limit_ui', 'limit_wc', 'api_limit')
GROUP BY
    user_email,
    srcIP
HAVING failedAttempts >= {threshold:UInt32}
ORDER BY failedAttempts DESC;
