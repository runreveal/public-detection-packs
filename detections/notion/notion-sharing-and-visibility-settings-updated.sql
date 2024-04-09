SELECT * from notion_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
and eventName in (
  'workspace.settings.allow_public_page_sharing_setting_updated',
  'workspace.settings.allow_guests_setting_updated',
  'workspace.settings.allow_content_export_setting_updated',
  'teamspace.settings.allow_public_page_sharing_setting_updated',
  'teamspace.settings.allow_guests_setting_updated',
  'teamspace.settings.allow_content_export_setting_updated'
) and JSONExtractString(detail, 'state') = 'enabled'
