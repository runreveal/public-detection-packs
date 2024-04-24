SELECT *
FROM notion_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND (eventName = 'teamspace.permissions.member_added') AND (JSONExtractString(detail, 'role') = 'owner')
;

