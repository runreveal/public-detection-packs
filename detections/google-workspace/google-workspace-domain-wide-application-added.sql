SELECT
  receivedAt, eventTime, eventName, id, sourceType,
  srcIP, srcASCountryCode, srcASNumber, srcASOrganization, srcCity,
  actor, resources, serviceName, tags,
  -- google workspace-specific
  `actor.email`, `id.applicationName`, `id.customerID`, events,
  ownerDomain,
  -- extract application name for dedup
  JSONExtractString(JSONExtractArrayRaw(JSONExtractArrayRaw(rawLog, 'events')[1], 'parameters')[1], 'value') as app_name
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND (eventName = 'ADD_APPLICATION') AND arrayExists(x -> (JSONExtractString(x, 'type') = 'DOMAIN_SETTINGS'), JSONExtractArrayRaw(rawLog, 'events'))
LIMIT 1 BY app_name
;
