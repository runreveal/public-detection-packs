SELECT * from google_workspace_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
AND eventName='login_failure'
