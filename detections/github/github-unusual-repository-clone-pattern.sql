-- GitHub Unusual Repository Clone Pattern Detection
-- Detects bulk cloning of repositories that may indicate data exfiltration

SELECT
  actor['login'] as actor_login,
  actor['email'] as actor_email,
  COUNT(*) as clone_count,
  COUNT(DISTINCT repo) as unique_repos_cloned,
  groupArray(DISTINCT repo) as repositories,
  MIN(receivedAt) as first_clone,
  MAX(receivedAt) as last_clone,
  -- Calculate severity based on volume
  CASE
    WHEN COUNT(*) >= 20 THEN 'HIGH'
    WHEN COUNT(*) >= 10 THEN 'MEDIUM'
    ELSE 'LOW'
  END as severity,
  any(actor) as actor_details,
  any(org) as org_details
FROM
  github_logs
WHERE
  -- Match git clone and fetch operations
  (action = 'git.clone'
   OR action = 'git.fetch'
   OR action = 'repo.download_zip'
   OR action = 'repo.packages_published')

  -- Exclude known bots and service accounts
  AND actor['login'] NOT LIKE '%[bot]'
  AND actor['email'] NOT LIKE '%noreply.github.com'

  -- Focus on private repositories if available
  AND (public_repo = 'false' OR repository_public = 'false' OR public_repo IS NULL)

  AND receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}

GROUP BY
  actor['login'],
  actor['email']

-- Alert when threshold is exceeded
HAVING COUNT(*) >= {threshold:UInt64}

ORDER BY clone_count DESC
