SELECT 
*
FROM 
  github_logs
WHERE 
  action IN (
    'ip_allow_list.enable',
    'ip_allow_list.disable',
    'ip_allow_list.enable_for_installed_apps',
    'ip_allow_list.disable_for_installed_apps',
    'ip_allow_list_entry.create',
    'ip_allow_list_entry.update',
    'ip_allow_list_entry.destroy'
  )
  AND receivedAt > {from:DateTime} 
  AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC 