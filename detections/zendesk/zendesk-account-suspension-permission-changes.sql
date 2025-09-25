SELECT *
FROM zendesk_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime})
  AND eventName IN ('create', 'update')
  AND (changeDescription LIKE '%suspended%'
       OR changeDescription LIKE '%permission%'
       OR changeDescription LIKE '%role%'
       OR changeDescription LIKE '%Permanently deleted user%'
       OR actionLabel LIKE '%Suspended%')
ORDER BY receivedAt DESC
