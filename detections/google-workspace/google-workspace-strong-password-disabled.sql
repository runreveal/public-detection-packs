SELECT
arrayJoin(events) as event,
JSONExtractString(event, 'type') as event_type,
JSONExtractString(event, 'name') as event_name,
-- Extract specific application setting parameters of interest
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'SETTING_NAME', JSONExtractArrayRaw(event, 'parameters')), 'value') as setting_name,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'NEW_VALUE', JSONExtractArrayRaw(event, 'parameters')), 'value') as new_value,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'OLD_VALUE', JSONExtractArrayRaw(event, 'parameters')), 'value') as old_value,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'APPLICATION_NAME', JSONExtractArrayRaw(event, 'parameters')), 'value') as application_name,
JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'ORG_UNIT_NAME', JSONExtractArrayRaw(event, 'parameters')), 'value') as org_unit_name,
  receivedAt, eventTime, eventName, id, sourceType,
  srcIP, srcASCountryCode, srcASNumber, srcASOrganization, srcCity,
  actor, resources, serviceName, tags,
  `actor.email`, `id.applicationName`, `id.customerID`,
  ownerDomain
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime})
  AND (`id.applicationName` = 'admin')
  AND (JSONExtractString(event, 'name') = 'CREATE_APPLICATION_SETTING')
  AND (JSONExtractString(event, 'type') = 'APPLICATION_SETTINGS')
  AND (lower(JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'NEW_VALUE', JSONExtractArrayRaw(event, 'parameters')), 'value')) = 'off')
  AND (JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'SETTING_NAME', JSONExtractArrayRaw(event, 'parameters')), 'value') = 'Password Management - Enforce strong password')
;
