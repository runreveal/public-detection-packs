SELECT *
FROM notion_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND (eventName IN ('workspace.settings.allow_public_page_sharing_setting_updated', 'workspace.settings.allow_guests_setting_updated', 'workspace.settings.allow_content_export_setting_updated', 'teamspace.settings.allow_public_page_sharing_setting_updated', 'teamspace.settings.allow_guests_setting_updated', 'teamspace.settings.allow_content_export_setting_updated')) AND (JSONExtractString(detail, 'state') = 'enabled')
;

