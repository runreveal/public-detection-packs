SELECT 
arrayJoin(events) as event,
arrayJoin(JSONExtractArrayRaw(event, 'parameters')) as param,
JSONExtractString(param, 'name') as paramName,
JSONExtractString(param, 'value') as paramValue,
JSONExtractString(event, 'type') as event_type,
JSONExtractString(event, 'name') as event_name,
-- Extract specific login parameters of interest
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'login_type', JSONExtractArrayRaw(event, 'parameters')), 'value') as login_type,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'login_challenge_method', JSONExtractArrayRaw(event, 'parameters')), 'value') as login_challenge_method,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'is_suspicious', JSONExtractArrayRaw(event, 'parameters')), 'value') as is_suspicious,
*
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime}) 
  AND (`id.applicationName` = 'login')
  AND (JSONExtractString(event, 'name') IN ('suspicious_login', 'suspicious_login_less_secure_app', 'suspicious_programmatic_login'))
; 