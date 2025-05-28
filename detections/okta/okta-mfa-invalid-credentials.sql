SELECT
  `actor.alternateID` as actor_email,
  `actor.displayName` as actor_name,
  outcome as result,
  JSONExtractString(rawLog, 'outcome', 'reason') as failure_reason,
  JSONExtractString(rawLog, 'debugContext', 'debugData', 'factor') as mfa_factor,
  JSONExtractString(rawLog, 'securityContext', 'asNumber') as as_number,
  JSONExtractString(rawLog, 'securityContext', 'asOrg') as as_org,
  srcIP as source_ip,
  JSONExtractString(rawLog, 'client', 'geographicalContext', 'country') as country,
  JSONExtractString(rawLog, 'client', 'geographicalContext', 'city') as city,
  JSONExtractString(rawLog, 'client', 'userAgent') as user_agent,
  `client.device` as device_type,
  *
FROM
  okta_logs
WHERE
  eventName = 'user.authentication.auth_via_mfa'
  AND outcome = 'FAILURE'
  AND JSONExtractString(rawLog, 'outcome', 'reason') = 'INVALID_CREDENTIALS'
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 