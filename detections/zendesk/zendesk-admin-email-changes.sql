SELECT *
FROM zendesk_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime})
  AND eventName = 'update'
  AND changeDescription LIKE '%email changed%'
  AND (changeDescription LIKE '%admin%'
       OR actorName LIKE '%admin%'
       OR changeDescription LIKE '%@%' AND changeDescription LIKE '%admin%')
ORDER BY receivedAt DESC
