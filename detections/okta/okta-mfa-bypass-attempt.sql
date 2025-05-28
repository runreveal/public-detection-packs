SELECT
  *
FROM
  okta_logs
WHERE
  eventName = 'user.mfa.attempt_bypass'
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 