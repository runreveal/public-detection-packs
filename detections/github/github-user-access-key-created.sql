SELECT
*
FROM 
github_logs
WHERE action IN (
 'public_key.create'
) AND
receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC 