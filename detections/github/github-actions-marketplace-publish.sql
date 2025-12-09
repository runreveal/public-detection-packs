-- GitHub Actions Marketplace Publish Detection
-- Detects GitHub Actions published to marketplace or action definitions created

SELECT
  CASE
    WHEN action LIKE '%publish%' THEN 'published'
    WHEN action LIKE '%create%' THEN 'created'
    WHEN action LIKE '%update%' THEN 'updated'
    ELSE 'modified'
  END as action_operation,
  -- Actions marketplace publishing is high severity
  CASE
    WHEN action LIKE '%marketplace%' THEN 'HIGH'
    WHEN action LIKE '%public%' THEN 'HIGH'
    ELSE 'MEDIUM'
  END as severity,
  *
FROM
  github_logs
WHERE
  -- Match marketplace and action publication events
  (action LIKE 'marketplace%'
   OR action LIKE '%action.publish%'
   OR action LIKE '%action.create%'
   OR action = 'repo.actions_enabled'
   OR action = 'repo.update_actions_access_settings'
   -- Also catch when action.yml/action.yaml files are added to public repos
   OR (action LIKE 'git.push'
       AND (file_path LIKE '%action.yml' OR file_path LIKE '%action.yaml')
       AND (public_repo = 'true' OR repository_public = 'true')))

  AND receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC
