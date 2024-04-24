SELECT *
FROM okta_logs
WHERE (eventType IN ('user.session.impersonation.grant', 'user.session.impersonation.initiate')) AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
;

