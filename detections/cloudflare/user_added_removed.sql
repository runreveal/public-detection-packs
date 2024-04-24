SELECT *
FROM cf_audit_logs
WHERE (eventName IN ('add_member', 'accept_member', 'account_member_delete')) AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
;

