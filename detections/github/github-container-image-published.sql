-- GitHub Container Image Published Detection
-- Detects container images published to GitHub Container Registry (ghcr.io)

SELECT
  CASE
    WHEN action LIKE '%published' THEN 'published'
    WHEN action LIKE '%pushed' THEN 'pushed'
    WHEN action LIKE '%updated' THEN 'updated'
    ELSE 'modified'
  END as container_operation,
  -- Calculate severity - container images are high risk
  CASE
    WHEN action LIKE '%published' OR action LIKE '%pushed' THEN 'HIGH'
    ELSE 'MEDIUM'
  END as severity,
  *
FROM
  github_logs
WHERE
  -- Match container registry and package actions for container type
  (action LIKE 'packages.package%'
   AND (package_type = 'container'
        OR package_type = 'docker'
        OR package_namespace LIKE '%ghcr.io%'
        OR package_namespace LIKE '%docker.pkg.github.com%'))

  -- Also match explicit container registry actions
  OR action LIKE 'registry.package%'
  OR action = 'packages.package_version_published'

  AND receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC
