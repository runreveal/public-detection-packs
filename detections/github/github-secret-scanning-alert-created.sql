SELECT 
*
FROM
  github_logs
WHERE
action IN (
 'secret_scanning_alert.create'
)
AND receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC 