SELECT *
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime}) 
  AND (receivedAt < {to:DateTime}) 
  AND (`id.applicationName` != 'access_transparency')
  AND (arrayExists(x -> JSONExtractString(x, 'type') = 'GSUITE_RESOURCE', events))
; 