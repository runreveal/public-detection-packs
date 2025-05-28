SELECT
  *
FROM
  okta_logs
WHERE
  eventType = 'app.generic.unauth_app_access_attempt'
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 