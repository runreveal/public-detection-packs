SELECT
  receivedAt, eventTime, eventName, id, sourceType,
  srcIP, srcASCountryCode, srcASNumber, srcASOrganization, srcCity,
  actor, resources, serviceName, tags,
  -- okta-specific
  eventType, severity, outcome,
  `actor.alternateID`, `actor.displayName`, `actor.id`, `actor.type`,
  `client.device`, `client.userAgent`,
  target, debugContext
FROM
  okta_logs
WHERE
  eventType = 'user.account.privilege.grant'
  AND outcome = 'SUCCESS'
  AND (debugContext LIKE '%administrator%' OR debugContext LIKE '%Administrator%')
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime}
