SELECT 
arrayJoin(events) as event,
JSONExtractString(event, 'type') as event_type,
JSONExtractString(event, 'name') as event_name,
-- Extract specific group member parameters of interest
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'USER_EMAIL', JSONExtractArrayRaw(event, 'parameters')), 'value') as user_email,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'GROUP_EMAIL', JSONExtractArrayRaw(event, 'parameters')), 'value') as group_email,
-- Extract domain and group prefix for analysis
splitByChar('@', JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'USER_EMAIL', JSONExtractArrayRaw(event, 'parameters')), 'value'))[2] as user_domain,
splitByChar('@', JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'GROUP_EMAIL', JSONExtractArrayRaw(event, 'parameters')), 'value'))[1] as group_prefix,
*
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime}) 
  AND (`id.applicationName` = 'admin')
  AND (JSONExtractString(event, 'name') = 'ADD_GROUP_MEMBER')
  AND (JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'USER_EMAIL', JSONExtractArrayRaw(event, 'parameters')), 'value') IS NOT NULL)
  AND (JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'GROUP_EMAIL', JSONExtractArrayRaw(event, 'parameters')), 'value') IS NOT NULL)
  AND (JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'USER_EMAIL', JSONExtractArrayRaw(event, 'parameters')), 'value') LIKE '%gserviceaccount.com')
  AND (NOT (splitByChar('@', JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'GROUP_EMAIL', JSONExtractArrayRaw(event, 'parameters')), 'value'))[1] LIKE 'sa-%'))
; 