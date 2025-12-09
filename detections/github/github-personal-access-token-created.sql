-- GitHub Personal Access Token Creation Detection
-- Detects creation of personal access tokens with elevated scopes

SELECT
  -- Determine severity based on token scopes if available
  CASE
    WHEN action = 'personal_access_token.create'
      AND (token_scopes LIKE '%admin%' OR token_scopes LIKE '%delete_repo%') THEN 'HIGH'
    WHEN action = 'personal_access_token.create'
      AND token_scopes LIKE '%repo%' THEN 'MEDIUM'
    WHEN action = 'oauth_access.create' THEN 'HIGH'
    ELSE 'MEDIUM'
  END as severity,
  CASE
    WHEN action LIKE '%create' THEN 'created'
    WHEN action LIKE '%access' THEN 'accessed'
    ELSE 'modified'
  END as token_operation,
  *
FROM
  github_logs
WHERE
  -- Match personal access token and OAuth token creation
  (action = 'personal_access_token.create'
   OR action = 'oauth_access.create'
   OR action = 'oauth_authorization.create'
   OR action = 'personal_access_token.access')

  AND receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC
