SELECT *
FROM okta_logs
WHERE (eventType IN ('system.api_token.create')) AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
;

