SELECT 
arrayJoin(events) as event,
arrayJoin(JSONExtractArrayRaw(event, 'parameters')) as param,
JSONExtractString(param, 'name') as paramName,
JSONExtractString(param, 'value') as paramValue,
JSONExtractString(event, 'type') as event_type,
JSONExtractString(event, 'name') as event_name,
-- Extract specific takeout parameters of interest
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'OBFUSCATED_CUSTOMER_TAKEOUT_REQUEST_ID', JSONExtractArrayRaw(event, 'parameters')), 'value') as takeout_request_id,
*
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime}) 
  AND (`id.applicationName` = 'admin')
  AND (JSONExtractString(event, 'name') LIKE 'CUSTOMER_TAKEOUT_%')
; 