SELECT * from notion_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
and eventName='workspace.settings.enforce_saml_sso_config_updated'
