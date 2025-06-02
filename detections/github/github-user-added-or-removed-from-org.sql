SELECT
*
FROM 
github_logs
WHERE action IN (
 'org.add_member',
 'org.remove_member'
) AND
receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC 