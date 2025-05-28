SELECT *
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime}) 
  AND (receivedAt < {to:DateTime}) 
  AND (`id.applicationName` = 'mobile')
  AND (arrayExists(x -> JSONExtractString(x, 'name') = 'SUSPICIOUS_ACTIVITY_EVENT', events))
; 