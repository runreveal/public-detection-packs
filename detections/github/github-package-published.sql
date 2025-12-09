-- GitHub Package Published Detection
-- Detects packages published to GitHub Packages registry

SELECT
  CASE
    WHEN action = 'packages.package_version_published' THEN 'published'
    WHEN action = 'packages.package_version_updated' THEN 'updated'
    WHEN action = 'packages.package_published' THEN 'published'
    ELSE 'modified'
  END as package_operation,
  -- Calculate severity based on patterns
  CASE
    WHEN action LIKE '%published'
      AND (created_at > now() - INTERVAL 7 DAY OR actor_created_at > now() - INTERVAL 30 DAY) THEN 'HIGH'
    WHEN action LIKE '%published' THEN 'MEDIUM'
    ELSE 'INFO'
  END as severity,
  *
FROM
  github_logs
WHERE
  -- Match package publishing and registry actions
  (action = 'packages.package_version_published'
   OR action = 'packages.package_published'
   OR action = 'packages.package_version_updated'
   OR action = 'packages.package_deleted'
   OR action LIKE 'package%publish%'
   OR action LIKE 'registry%publish%')

  AND receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC
