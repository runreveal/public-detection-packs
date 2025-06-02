SELECT
*
FROM 
github_logs
WHERE action IN (
 'team.add_member',
 'team.add_repository',
 'team.change_parent_team',
 'team.create',
 'team.destroy',
 'team.remove_member',
 'team.remove_repository'
) AND
receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC 