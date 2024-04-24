SELECT *
FROM notion_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND (eventName = 'workspace.scim_token_generated')
;

