SELECT *
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND (id.applicationName = 'admin') AND (eventName = 'CHANGE_PASSWORD')
;

