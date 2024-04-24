SELECT *
FROM cf_audit_logs
WHERE (eventName IN ('token_create', 'rotate_API_key')) AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
;

