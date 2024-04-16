SELECT * from google_workspace_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
AND eventName='change_calendar_acls'
and rawLog like '%__public_principal__@public.calendar.google.com%'

