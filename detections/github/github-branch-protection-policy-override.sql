SELECT 
  *
FROM 
  github_logs
WHERE 
  action IN (
    'protected_branch.policy_override'
  )
  AND receivedAt > {from:DateTime} 
  AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC 