SELECT *
FROM okta_logs
WHERE (eventType IN ('security.threat.detected', 'security.attack.start', 'security.attack.end', 'debugContext.debugData.threatSuspected')) AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
;

