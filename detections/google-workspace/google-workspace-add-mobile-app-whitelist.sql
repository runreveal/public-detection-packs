SELECT 
arrayJoin(events) as event,
arrayJoin(JSONExtractArrayRaw(event, 'parameters')) as param,
JSONExtractString(param, 'name') as paramName,
JSONExtractString(param, 'value') as paramValue,
*
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime}) 
  AND eventName='ADD_MOBILE_APPLICATION_TO_WHITELIST'
  AND paramName='MOBILE_APP_PACKAGE_ID'
; 