SELECT *
FROM zendesk_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime})
  AND eventName = 'destroy'
  AND zendeskSourceType = 'account'
  AND changeDescription LIKE '%deletion for % users%'
ORDER BY receivedAt DESC
