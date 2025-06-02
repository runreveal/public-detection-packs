SELECT 
*
FROM 
  github_logs
WHERE 
  action IN ('repo.add_member', 'repo.remove_member')
  AND visibility != 'public'
  AND receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}