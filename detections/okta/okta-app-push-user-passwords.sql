SELECT
  `actor.alternateID` as actor_email,
  JSONExtractString(rawLog, 'outcome', 'reason') as outcome_reason,
  arrayFirst(x -> 1, target) as target_app,
  JSONExtractString(arrayFirst(x -> 1, target), 'displayName') as app_display_name,
  JSONExtractString(arrayFirst(x -> 1, target), 'id') as app_id,
  *
FROM
  okta_logs
WHERE
  eventName = 'application.lifecycle.update'
  AND JSONExtractString(rawLog, 'outcome', 'reason') LIKE '%Pushing user passwords%'
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 