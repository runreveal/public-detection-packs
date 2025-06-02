SELECT 
 
  -- Add security-related severity classification
  CASE 
    -- Critical severity actions
    WHEN action IN (
      'dependabot_alerts.disable',
      'dependabot_security_updates.disable', 
      'secret_scanning.disable',
      'business.disable_oidc', 
      'business.disable_saml',
      'business.disable_two_factor_requirement',
      'business_advanced_security.disabled',
      'business_secret_scanning.disable',
      'business_secret_scanning_push_protection.disable',
      'org.advanced_security_disabled_on_all_repos',
      'repo.advanced_security_disabled'
    ) THEN 'CRITICAL'
    
    -- High severity actions
    WHEN action IN (
      'dependabot_alerts_new_repos.disable',
      'dependabot_security_updates_new_repos.disable',
      'repository_secret_scanning_push_protection.disable',
      'secret_scanning_new_repos.disable',
      'business_advanced_security.disabled_for_new_repos',
      'business_secret_scanning.disabled_for_new_repos',
      'business_secret_scanning_custom_pattern_push_protection.disabled',
      'business_secret_scanning_push_protection.disabled_for_new_repos',
      'business_secret_scanning_push_protection_custom_message.disable',
      'org.advanced_security_disabled_for_new_repos',
      'org.advanced_security_policy_selected_member_disabled',
      'repo.advanced_security_policy_selected_member_disabled',
      'repository_vulnerability_alerts.disable'
    ) THEN 'HIGH'
    
    -- Medium severity actions
    WHEN action IN (
      'bypass',
      'business.members_can_update_protected_branches.disable',
      'business.referrer_override_disable'
    ) THEN 'MEDIUM'
    
    -- Default severity
    ELSE 'LOW'
  END as severity,
  *
FROM 
  github_logs
WHERE 
  action IN (
    -- Dependabot related actions
    'dependabot_alerts.disable',
    'dependabot_alerts_new_repos.disable',
    'dependabot_security_updates.disable',
    'dependabot_security_updates_new_repos.disable',
    
    -- Secret scanning related actions
    'repository_secret_scanning_push_protection.disable',
    'secret_scanning.disable',
    'secret_scanning_new_repos.disable',
    'bypass',
    
    -- Enterprise-level security actions
    'business.disable_oidc',
    'business.disable_saml',
    'business.disable_two_factor_requirement',
    'business.members_can_update_protected_branches.disable',
    'business.referrer_override_disable',
    'business_advanced_security.disabled',
    'business_advanced_security.disabled_for_new_repos',
    'business_secret_scanning.disable',
    'business_secret_scanning.disabled_for_new_repos',
    'business_secret_scanning_custom_pattern_push_protection.disabled',
    'business_secret_scanning_push_protection.disable',
    'business_secret_scanning_push_protection.disabled_for_new_repos',
    'business_secret_scanning_push_protection_custom_message.disable',
    
    -- Organization-level security actions
    'org.advanced_security_disabled_for_new_repos',
    'org.advanced_security_disabled_on_all_repos',
    'org.advanced_security_policy_selected_member_disabled',
    
    -- Repository-level security actions
    'repo.advanced_security_disabled',
    'repo.advanced_security_policy_selected_member_disabled',
    'repository_vulnerability_alerts.disable'
  )
AND receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY 
  severity ASC, -- Show most severe events first
  eventTime DESC -- Then most recent events 