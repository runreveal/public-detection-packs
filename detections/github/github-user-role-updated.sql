SELECT
*
FROM 
github_logs
WHERE action IN (
 'org.update_member'
) AND
receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC 