SELECT *
FROM zendesk_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime})
  AND eventName = 'login'
  AND actionLabel = 'Signed in'
  AND srcASCountryCode NOT IN ('US', 'CA', 'GB', 'AU')  -- Adjust based on your expected countries
ORDER BY receivedAt DESC
