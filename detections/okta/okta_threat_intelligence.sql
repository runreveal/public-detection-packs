select * from okta_logs where eventType in ('security.threat.detected',
  'security.attack.start', 'security.attack.end',
  'debugContext.debugData.threatSuspected') and receivedAt BETWEEN {from:DateTime} AND {to:DateTime}