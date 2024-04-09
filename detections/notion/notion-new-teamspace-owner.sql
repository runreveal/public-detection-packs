SELECT * from notion_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
and eventName='teamspace.permissions.member_added'
and JSONExtractString(detail, 'role') = 'owner'
