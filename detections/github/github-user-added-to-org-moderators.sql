SELECT
*
FROM 
github_logs
WHERE action IN (
 'organization_moderators.add_user'
) AND
receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC 