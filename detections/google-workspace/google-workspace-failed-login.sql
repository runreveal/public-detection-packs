SELECT
  receivedAt, eventTime, eventName, id, sourceType,
  srcIP, srcASCountryCode, srcASNumber, srcASOrganization, srcCity,
  actor, resources, serviceName, tags,
  -- google workspace-specific
  `actor.email`, `id.applicationName`, `id.customerID`, events,
  ownerDomain
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND (eventName = 'login_failure')
;
