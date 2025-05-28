SELECT
  `actor.alternateID` as actor_email,
  `actor.displayName` as actor_name,
  eventName as support_reset_event,
  arrayFirst(x -> 1, target) as target_user,
  JSONExtractString(arrayFirst(x -> 1, target), 'alternateId') as target_user_email,
  JSONExtractString(arrayFirst(x -> 1, target), 'displayName') as target_user_name,
  JSONExtractString(arrayFirst(x -> 1, target), 'id') as target_user_id,
  `transaction.id` as transaction_id,
  JSONExtractString(rawLog, 'userAgent', 'rawUserAgent') as raw_user_agent,
  JSONExtractString(rawLog, 'client', 'geographicalContext', 'country') as country,
  outcome as result,
  *
FROM
  okta_logs
WHERE
  eventName IN (
    'user.account.reset_password',
    'user.mfa.factor.update',
    'system.mfa.factor.deactivate',
    'user.mfa.attempt_bypass'
  )
  AND `actor.alternateID` = 'system@okta.com'
  AND `transaction.id` = 'unknown'
  AND JSONExtractString(rawLog, 'userAgent', 'rawUserAgent') IS NULL
  AND JSONExtractString(rawLog, 'client', 'geographicalContext', 'country') IS NULL
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 