SELECT 
arrayJoin(events) as event,
arrayJoin(JSONExtractArrayRaw(event, 'parameters')) as param,
JSONExtractString(param, 'name') as paramName,
JSONExtractString(param, 'value') as paramValue,
JSONExtractString(event, 'type') as event_type,
JSONExtractString(event, 'name') as event_name,
-- Extract specific calendar sharing parameters of interest
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'SETTING_NAME', JSONExtractArrayRaw(event, 'parameters')), 'value') as setting_name,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'NEW_VALUE', JSONExtractArrayRaw(event, 'parameters')), 'value') as new_value,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'OLD_VALUE', JSONExtractArrayRaw(event, 'parameters')), 'value') as old_value,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'ORG_UNIT_NAME', JSONExtractArrayRaw(event, 'parameters')), 'value') as org_unit_name,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'DOMAIN_NAME', JSONExtractArrayRaw(event, 'parameters')), 'value') as domain_name,
*
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime}) 
  AND (`id.applicationName` = 'admin')
  AND (JSONExtractString(event, 'name') = 'CHANGE_CALENDAR_SETTING')
  AND (JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'SETTING_NAME', JSONExtractArrayRaw(event, 'parameters')), 'value') = 'SHARING_OUTSIDE_DOMAIN')
  AND (JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'NEW_VALUE', JSONExtractArrayRaw(event, 'parameters')), 'value') IN ('READ_WRITE_ACCESS', 'READ_ONLY_ACCESS', 'MANAGE_ACCESS'))
; 