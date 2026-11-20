SELECT
  `actor.alternateID` as actor_email,
  `actor.displayName` as actor_name,
  outcome as result,
  outcome.reason as outcome_reason,
  JSONExtractString(rawLog, 'client', 'geographicalContext', 'country') as country,
  JSONExtractString(rawLog, 'client', 'geographicalContext', 'city') as city,
  `client.device` as device_type,
  srcIP as source_ip,
  *
FROM
  okta_logs
WHERE
  eventName = 'user.authentication.auth_via_mfa'
  AND outcome.result = 'FAILURE'
  AND outcome.reason = 'FastPass declined phishing attempt'
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 