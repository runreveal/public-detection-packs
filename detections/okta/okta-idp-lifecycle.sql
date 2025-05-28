SELECT
  *
FROM
  okta_logs
WHERE
  eventType LIKE 'system.idp.lifecycle.%'
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 