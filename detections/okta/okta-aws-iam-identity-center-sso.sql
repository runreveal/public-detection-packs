SELECT
  `actor.alternateID` as actor_email,
  `actor.displayName` as actor_name,
  outcome as result,
  arrayFirst(x -> JSONExtractString(x, 'displayName') LIKE '%AWS IAM Identity Center%', target) as aws_target,
  JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'displayName') LIKE '%AWS IAM Identity Center%', target), 'displayName') as aws_app_name,
  JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'displayName') LIKE '%AWS IAM Identity Center%', target), 'id') as aws_app_id,
  srcIP as source_ip,
  JSONExtractString(rawLog, 'client', 'geographicalContext', 'country') as country,
  JSONExtractString(rawLog, 'client', 'geographicalContext', 'city') as city,
  JSONExtractString(rawLog, 'client', 'userAgent') as user_agent,
  `client.device` as device_type,
  *
FROM
  okta_logs
WHERE
  eventName = 'user.authentication.sso'
  AND outcome = 'SUCCESS'
  AND arrayExists(x -> JSONExtractString(x, 'displayName') LIKE '%AWS IAM Identity Center%', target)
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 