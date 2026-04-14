SELECT
  receivedAt, eventTime, eventName, id, sourceType,
  srcIP, srcASCountryCode, srcASNumber, srcASOrganization, srcCity,
  actor, resources, serviceName, tags,
  -- okta-specific
  eventType, severity, outcome, securityContext,
  `actor.alternateID`, `actor.displayName`, `actor.id`, `actor.type`,
  `client.device`, `client.userAgent`, `client.os`, `client.browser`,
  target, debugContext,
  `debugContext.debugData.threatSuspected`, `debugContext.debugData.behaviors`
FROM okta_logs
WHERE (eventType IN ('security.threat.detected', 'security.attack.start', 'security.attack.end', 'debugContext.debugData.threatSuspected')) AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
;
