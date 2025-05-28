SELECT 
arrayJoin(events) as event,
JSONExtractString(event, 'name') as event_name,
JSONExtractString(event, 'type') as event_type,
-- Extract grantee_email parameter
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'grantee_email', JSONExtractArrayRaw(event, 'parameters')), 'value') as grantee_email,
-- Extract other relevant calendar parameters
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'calendar_id', JSONExtractArrayRaw(event, 'parameters')), 'value') as calendar_id,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'role', JSONExtractArrayRaw(event, 'parameters')), 'value') as role,
*
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime}) 
  AND (JSONExtractString(arrayJoin(events), 'name') = 'change_calendar_acls')
  AND (JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'grantee_email', JSONExtractArrayRaw(arrayJoin(events), 'parameters')), 'value') = '__public_principal__@public.calendar.google.com')
; 