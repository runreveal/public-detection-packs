SELECT
  `actor.alternateID` as actor_email,
  `actor.displayName` as actor_name,
  eventName as security_event,
  arrayFirst(x -> 1, target) as target_object,
  JSONExtractString(arrayFirst(x -> 1, target), 'displayName') as target_name,
  JSONExtractString(arrayFirst(x -> 1, target), 'id') as target_id,
  JSONExtractString(arrayFirst(x -> 1, target), 'type') as target_type,
  outcome as result,
  *
FROM
  okta_logs
WHERE
  eventName IN (
    'network_zone.rule.disabled',
    'policy.rule.delete',
    'policy.rule.update',
    'policy.rule.deactivate',
    'policy.rule.invalidate',
    'security.zone.remove_blacklist',
    'zone.deactivate',
    'zone.delete',
    'zone.update'
  )
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 