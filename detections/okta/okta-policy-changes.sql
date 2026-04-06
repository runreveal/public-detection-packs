SELECT
    * EXCEPT(rawLog),
    JSONExtractArrayRaw(rawLog, 'target') tgt
FROM runreveal.logs
WHERE (sourceType = 'okta') AND (
  eventName IN (
    'policy.lifecycle.update',
    'policy.rule.update',
    'application.policy.sign_on.update',
    'policy.rule.delete', 
    'policy.rule.deactivate'
  )
) AND (receivedAt < {to:DateTime}) AND (receivedAt >= {from:DateTime})