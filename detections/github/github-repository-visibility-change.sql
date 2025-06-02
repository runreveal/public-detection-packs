SELECT 
*
FROM
  github_logs
WHERE
action IN (
 'repo.access'
)
AND visibility != 'public'
AND public_repo != 'false'
AND receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC 