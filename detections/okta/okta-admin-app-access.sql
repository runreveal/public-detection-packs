SELECT
  *
FROM
  okta_logs
WHERE
  eventType = 'user.session.access_admin_app'
  AND outcome = 'SUCCESS'
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 