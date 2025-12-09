-- GitHub Actions Self-Hosted Runner Detection
-- Detects registration of self-hosted runners to organization or repositories

SELECT
  CASE
    WHEN action LIKE '%.create' THEN 'created'
    WHEN action LIKE '%.register' THEN 'registered'
    ELSE 'modified'
  END as runner_operation,
  -- All runner additions are high severity
  'HIGH' as severity,
  *
FROM
  github_logs
WHERE
  -- Match self-hosted runner related actions
  (action LIKE 'self_hosted_runner%'
   OR action LIKE 'runner%'
   OR action = 'org.runner_group_created'
   OR action = 'org.runner_group_updated'
   OR action = 'org.runner_group_runner_added'
   OR action = 'repo.register_self_hosted_runner'
   OR action = 'repo.remove_self_hosted_runner')

  AND receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC
