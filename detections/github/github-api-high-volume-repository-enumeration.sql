-- GitHub API High Volume Repository Enumeration Detection
-- Detects high volumes of repository enumeration activity

SELECT
  actor['login'] as actor_login,
  actor['email'] as actor_email,
  COUNT(*) as enumeration_count,
  COUNT(DISTINCT repo) as unique_repos,
  COUNT(DISTINCT action) as unique_actions,
  groupArray(DISTINCT action) as actions,
  MIN(receivedAt) as first_seen,
  MAX(receivedAt) as last_seen,
  'MEDIUM' as severity,
  any(actor) as actor,
  any(org) as org
FROM
  github_logs
WHERE
  -- Match repository enumeration and discovery actions
  (action LIKE 'repo.access'
   OR action LIKE 'repo.archived'
   OR action LIKE 'repo.list%'
   OR action = 'repo.download_zip'
   OR action = 'repo.pages_build'
   OR action LIKE 'git.clone'
   OR action LIKE 'git.fetch'
   OR action LIKE 'repo_content.view')

  -- Exclude known service accounts and bots
  AND actor['login'] NOT LIKE '%[bot]'
  AND actor['email'] NOT LIKE '%noreply.github.com'

  AND receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}

GROUP BY
  actor['login'],
  actor['email']

-- Alert when a single actor accesses many repositories
HAVING COUNT(*) >= {threshold:UInt64}

ORDER BY enumeration_count DESC
