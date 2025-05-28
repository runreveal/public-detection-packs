SELECT
  `actor.alternateID` as actor_email,
  arrayFirst(x -> JSONExtractString(x, 'displayName') = 'Okta Admin Console', target) as admin_console_target,
  JSONExtractString(rawLog, 'debugContext', 'debugData', 'behaviors') as behaviors,
  JSONExtractString(rawLog, 'debugContext', 'debugData', 'logOnlySecurityData') as log_only_security_data,
  *
FROM
  okta_logs
WHERE
  eventName = 'policy.evaluate_sign_on'
  AND arrayExists(x -> JSONExtractString(x, 'displayName') = 'Okta Admin Console', target)
  AND (
    -- Check behaviors field for both New Device=POSITIVE and New IP=POSITIVE
    (JSONExtractString(rawLog, 'debugContext', 'debugData', 'behaviors') LIKE '%New Device=POSITIVE%' 
     AND JSONExtractString(rawLog, 'debugContext', 'debugData', 'behaviors') LIKE '%New IP=POSITIVE%')
    OR
    -- Check logOnlySecurityData for the same conditions
    (JSONExtractString(rawLog, 'debugContext', 'debugData', 'logOnlySecurityData') LIKE '%"New Device":"POSITIVE"%'
     AND JSONExtractString(rawLog, 'debugContext', 'debugData', 'logOnlySecurityData') LIKE '%"New IP":"POSITIVE"%')
  )
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 