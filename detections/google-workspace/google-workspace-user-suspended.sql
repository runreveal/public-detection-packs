SELECT 
arrayJoin(events) as event,
arrayJoin(JSONExtractArrayRaw(event, 'parameters')) as param,
JSONExtractString(param, 'name') as paramName,
JSONExtractString(param, 'value') as paramValue,
JSONExtractString(event, 'type') as event_type,
JSONExtractString(event, 'name') as event_name,
-- Extract specific user management parameters of interest
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'USER_EMAIL', JSONExtractArrayRaw(event, 'parameters')), 'value') as user_email,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'USER_NAME', JSONExtractArrayRaw(event, 'parameters')), 'value') as user_name,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'ORG_UNIT_NAME', JSONExtractArrayRaw(event, 'parameters')), 'value') as org_unit_name,
*
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime}) 
  AND (`id.applicationName` = 'admin')
  AND (JSONExtractString(event, 'name') IN ('SUSPEND_USER', 'DELETE_USER'))
; 