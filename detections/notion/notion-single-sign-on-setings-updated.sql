SELECT *
FROM notion_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND (eventName = 'workspace.settings.enforce_saml_sso_config_updated')
;

