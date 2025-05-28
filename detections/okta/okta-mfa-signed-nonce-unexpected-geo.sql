SELECT
  `actor.alternateID` as actor_email,
  JSONExtractString(rawLog, 'client', 'geographicalContext', 'country') as country,
  JSONExtractString(rawLog, 'debugContext', 'debugData', 'factor') as mfa_factor,
  `client.device` as device_type,
  *
FROM
  okta_logs
WHERE
  eventType = 'user.authentication.auth_via_mfa'
  AND outcome = 'SUCCESS'
  AND `client.device` = 'Computer'
  AND JSONExtractString(rawLog, 'debugContext', 'debugData', 'factor') = 'SIGNED_NONCE'
  AND JSONExtractString(rawLog, 'client', 'geographicalContext', 'country') NOT IN ('United States', 'Canada', 'United Kingdom', 'Australia', 'Germany', 'France', 'Netherlands')
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 