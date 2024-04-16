SELECT * from google-workspace_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
AND eventName='CREATE_ROLE' AND rawLog like '%DELEGATED_ADMIN_SETTINGS%'
