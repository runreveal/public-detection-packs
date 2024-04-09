SELECT * from notion_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
and eventName in (
  'page.permissions.shared_to_public_role_added',
  'page.permissions.shared_to_public_role_updated'
)
