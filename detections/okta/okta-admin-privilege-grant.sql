SELECT
  *
FROM
  okta_logs
WHERE
  eventType = 'user.account.privilege.grant'
  AND outcome = 'SUCCESS'
  AND (debugContext LIKE '%administrator%' OR debugContext LIKE '%Administrator%')
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 