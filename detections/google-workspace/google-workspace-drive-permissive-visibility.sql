SELECT 
arrayJoin(events) as event,
arrayJoin(JSONExtractArrayRaw(event, 'parameters')) as param,
JSONExtractString(param, 'name') as paramName,
JSONExtractString(param, 'value') as paramValue,
JSONExtractString(event, 'type') as event_type,
JSONExtractString(event, 'name') as event_name,
-- Extract specific parameters of interest
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'doc_title', JSONExtractArrayRaw(event, 'parameters')), 'value') as doc_title,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'doc_id', JSONExtractArrayRaw(event, 'parameters')), 'value') as doc_id,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'doc_type', JSONExtractArrayRaw(event, 'parameters')), 'value') as doc_type,
*
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime}) 
  AND (`id.applicationName` = 'drive')
  AND (JSONExtractString(event, 'type') = 'access')
  AND (JSONExtractString(event, 'name') IN ('create', 'move', 'upload', 'edit'))
  AND (paramName = 'visibility')
  AND (paramValue IN ('people_with_link', 'public_on_the_web'))
; 