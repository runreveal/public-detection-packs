SELECT
  `actor.alternateID` as actor_email,
  `actor.displayName` as actor_name,
  eventName as token_reuse_event,
  arrayFirst(x -> 1, target) as target_app,
  JSONExtractString(arrayFirst(x -> 1, target), 'displayName') as app_display_name,
  JSONExtractString(arrayFirst(x -> 1, target), 'id') as app_id,
  srcIP as source_ip,
  JSONExtractString(rawLog, 'client', 'geographicalContext', 'country') as country,
  JSONExtractString(rawLog, 'client', 'geographicalContext', 'city') as city,
  JSONExtractString(rawLog, 'client', 'userAgent') as user_agent,
  outcome as result,
  *
FROM
  okta_logs
WHERE
  eventName IN (
    'app.oauth2.as.token.detect_reuse',
    'app.oauth2.token.detect_reuse'
  )
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 