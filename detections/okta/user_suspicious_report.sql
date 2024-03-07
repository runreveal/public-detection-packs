select * from okta_logs where
  eventType='user.account.report_suspicious_activity_by_enduser' 
  and receivedAt > {from:DateTime} and receivedAt < {to:DateTime}