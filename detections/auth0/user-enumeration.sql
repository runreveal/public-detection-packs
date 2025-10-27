SELECT
    srcIP,
    srcASCountryCode,
    srcCity,
    groupUniqArray(user_email) AS attempted_users,
    count(*) AS total_attempts,
    count(DISTINCT user_email) AS unique_users_tried,
    min(receivedAt) AS first_attempt,
    max(receivedAt) AS last_attempt,
    groupArray(type) AS event_types
FROM auth0_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime})
  AND type IN ('f', 'fu', 'fp', 'fn')
  AND user_email != ''
GROUP BY
    srcIP,
    srcASCountryCode,
    srcCity
HAVING unique_users_tried >= {threshold:UInt32}
ORDER BY unique_users_tried DESC;
