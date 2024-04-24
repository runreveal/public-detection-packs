SELECT *
FROM notion_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND (eventName IN ('page.permissions.shared_to_public_role_added', 'page.permissions.shared_to_public_role_updated'))
;

