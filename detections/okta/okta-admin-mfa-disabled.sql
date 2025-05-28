SELECT
   *
FROM
  okta_logs
WHERE
  eventType IN (
    'user.mfa.factor.deactivate',
    'user.mfa.factor.reset_all',
    'policy.lifecycle.update',
    'policy.rule.update'
  )
  AND (
    -- Check if it's an admin user being affected
    JSONExtractString(rawLog, 'target', '0', 'alternateId') LIKE '%admin%'
    OR JSONExtractString(rawLog, 'target', '0', 'displayName') LIKE '%admin%'
    OR `actor.alternateID` LIKE '%admin%'
    OR `actor.displayName` LIKE '%admin%'
    -- Or check if it's a policy change affecting MFA
    OR (eventType LIKE 'policy.%' AND rawLog LIKE '%mfa%')
  )
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 