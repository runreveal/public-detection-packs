SELECT
  `actor.alternateID` as actor_email,
  `actor.displayName` as actor_name,
  eventName as policy_event,
  arrayFirst(x -> 1, target) as target_policy,
  JSONExtractString(arrayFirst(x -> 1, target), 'displayName') as policy_name,
  JSONExtractString(arrayFirst(x -> 1, target), 'id') as policy_id,
  JSONExtractString(arrayFirst(x -> 1, target), 'type') as target_type,
  outcome as result,
  *
FROM
  okta_logs
WHERE
  eventName IN (
    'policy.rule.delete',
    'policy.rule.update',
    'policy.rule.deactivate',
    'policy.rule.invalidate'
  )
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 