SELECT
  `actor.alternateID` as actor_email,
  arrayFirst(x -> JSONExtractString(x, 'type') = 'User', target) as target_user,
  JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'type') = 'User', target), 'alternateId') as target_user_email,
  arrayFirst(x -> JSONExtractString(x, 'type') = 'AppInstance', target) as target_app,
  JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'type') = 'AppInstance', target), 'alternateId') as target_app_name,
  JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'type') = 'AppInstance', target), 'displayName') as target_app_display_name,
  *
FROM
  okta_logs
WHERE
  eventName = 'application.user_membership.show_password'
  AND `actor.alternateID` != JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'type') = 'User', target), 'alternateId')
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 