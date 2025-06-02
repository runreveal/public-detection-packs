SELECT 
*
FROM
  github_logs
WHERE
action LIKE 'repository_ruleset.%'
AND receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC 