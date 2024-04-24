SELECT *
FROM okta_logs
WHERE (eventType = 'user.account.report_suspicious_activity_by_enduser') AND (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime})
;

