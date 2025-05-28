SELECT
  `actor.alternateID` as actor_email,
  arrayFirst(x -> JSONExtractString(x, 'displayName') LIKE '%Org2Org%', target) as org2org_target,
  JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'displayName') LIKE '%Org2Org%', target), 'displayName') as app_display_name,
  JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'displayName') LIKE '%Org2Org%', target), 'id') as app_id,
  eventName as lifecycle_event,
  *
FROM
  okta_logs
WHERE
  eventName IN (
    'application.lifecycle.update',
    'application.lifecycle.create', 
    'application.lifecycle.activate'
  )
  AND arrayExists(x -> JSONExtractString(x, 'displayName') LIKE '%Org2Org%', target)
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 