SELECT * from google_workspace_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
and id.applicationName = 'admin' and eventName='CHANGE_PASSWORD'
