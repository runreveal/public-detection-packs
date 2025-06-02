SELECT 
  *
FROM 
  github_logs
WHERE 
  action IN (
    'org.saml_disabled',
    'org.saml_enabled',
    'org.disable_two_factor_requirement',
    'org.enable_two_factor_requirement',
    'org.update_saml_provider_settings',
    'org.enable_oauth_app_restrictions',
    'org.disable_oauth_app_restrictions'
  )
  AND receivedAt > {from:DateTime} 
  AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC 