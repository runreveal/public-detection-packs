SELECT
    session_id,
    user_email,
    user_id,
    groupUniqArray(srcIP) AS unique_ips,
    groupUniqArray(srcASCountryCode) AS unique_countries,
    count(*) AS event_count,
    min(receivedAt) AS first_use,
    max(receivedAt) AS last_use
FROM auth0_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime})
  AND session_id != ''
  AND session_id IS NOT NULL
GROUP BY
    session_id,
    user_email,
    user_id
HAVING length(unique_ips) > {threshold:UInt32}
ORDER BY length(unique_ips) DESC;
