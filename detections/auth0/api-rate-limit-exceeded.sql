SELECT
    srcIP,
    user_email,
    client_name,
    srcASCountryCode,
    count(*) AS rate_limit_hits,
    groupArray(type) AS event_types,
    groupArray(description) AS descriptions,
    min(receivedAt) AS first_hit,
    max(receivedAt) AS last_hit
FROM auth0_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime})
  AND type IN ('limit_wc', 'limit_ui', 'limit_mu', 'limit_delegation', 'api_limit')
GROUP BY
    srcIP,
    user_email,
    client_name,
    srcASCountryCode
HAVING rate_limit_hits >= {threshold:UInt32}
ORDER BY rate_limit_hits DESC;
