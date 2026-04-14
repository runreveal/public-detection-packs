SELECT
  receivedAt, eventTime, eventName, id, sourceType,
  srcIP, srcASCountryCode, srcASNumber, srcASOrganization, srcCity,
  actor, resources, serviceName, tags,
  -- notion-specific
  notion_workspace_id, notion_workspace_name, object, notion_type, detail
FROM notion_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND (eventName = 'workspace.settings.enforce_saml_sso_config_updated')
;
