SELECT
  `actor.alternateID` as actor_email,
  `actor.displayName` as actor_name,
  eventName as impersonation_event,
  arrayFirst(x -> 1, target) as target_user,
  JSONExtractString(arrayFirst(x -> 1, target), 'alternateId') as target_user_email,
  JSONExtractString(arrayFirst(x -> 1, target), 'displayName') as target_user_name,
  JSONExtractString(arrayFirst(x -> 1, target), 'id') as target_user_id,
  outcome as result,
  srcIP as source_ip,
  JSONExtractString(rawLog, 'client', 'geographicalContext', 'country') as country,
  JSONExtractString(rawLog, 'client', 'geographicalContext', 'city') as city,
  JSONExtractString(rawLog, 'client', 'userAgent') as user_agent,
  *
FROM
  okta_logs
WHERE
  eventName IN (
    'user.session.impersonation.grant',
    'user.session.impersonation.initiate'
  )
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 