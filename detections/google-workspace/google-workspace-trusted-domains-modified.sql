SELECT 
arrayJoin(events) as event,
JSONExtractString(event, 'type') as event_type,
JSONExtractString(event, 'name') as event_name,
-- Extract specific domain parameters of interest
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'DOMAIN_NAME', JSONExtractArrayRaw(event, 'parameters')), 'value') as domain_name,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'OLD_VALUE', JSONExtractArrayRaw(event, 'parameters')), 'value') as old_value,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'NEW_VALUE', JSONExtractArrayRaw(event, 'parameters')), 'value') as new_value,
*
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime}) 
  AND (`id.applicationName` = 'admin')
  AND (JSONExtractString(event, 'type') = 'DOMAIN_SETTINGS')
  AND (JSONExtractString(event, 'name') LIKE '%_TRUSTED_DOMAINS')
; 