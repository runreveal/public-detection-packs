SELECT 
  distinct on (eventName, `actor.email`)
  *
from google-workspace_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
and eventName='CUSTOMER_TAKEOUT_CREATED'
