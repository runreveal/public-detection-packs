SELECT
arrayJoin(events) as event,
JSONExtractString(event, 'name') as event_name,
JSONExtractString(event, 'type') as event_type,
-- Extract device compromised state parameter
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'DEVICE_COMPROMISED_STATE', JSONExtractArrayRaw(event, 'parameters')), 'value') as device_compromised_state,
-- Extract other relevant device parameters
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'DEVICE_ID', JSONExtractArrayRaw(event, 'parameters')), 'value') as device_id,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'DEVICE_TYPE', JSONExtractArrayRaw(event, 'parameters')), 'value') as device_type,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'USER_EMAIL', JSONExtractArrayRaw(event, 'parameters')), 'value') as user_email,
  receivedAt, eventTime, eventName, id, sourceType,
  srcIP, srcASCountryCode, srcASNumber, srcASOrganization, srcCity,
  actor, resources, serviceName, tags,
  `actor.email`, `id.applicationName`, `id.customerID`,
  ownerDomain
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime})
  AND (`id.applicationName` = 'mobile')
  AND (JSONExtractString(event, 'name') = 'DEVICE_COMPROMISED_EVENT')
  AND (JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'DEVICE_COMPROMISED_STATE', JSONExtractArrayRaw(event, 'parameters')), 'value') = 'COMPROMISED')
;
