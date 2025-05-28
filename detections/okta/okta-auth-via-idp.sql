SELECT
  *
FROM
  okta_logs
WHERE
  eventName = 'user.authentication.auth_via_IDP'
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 