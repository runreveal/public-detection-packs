-- GitHub Actions Workflow Modification Detection
-- Detects creation, modification, or deletion of GitHub Actions workflows

SELECT
  CASE
    WHEN action LIKE '%.create' THEN 'created'
    WHEN action LIKE '%.update' THEN 'updated'
    WHEN action LIKE '%.destroy' THEN 'deleted'
    ELSE 'modified'
  END as workflow_operation,
  -- Calculate severity based on action
  CASE
    WHEN action LIKE '%.create' THEN 'HIGH'
    WHEN action LIKE '%.update' THEN 'MEDIUM'
    WHEN action LIKE '%.destroy' THEN 'MEDIUM'
    ELSE 'INFO'
  END as severity,
  *
FROM
  github_logs
WHERE
  -- Match workflow-related actions
  (action LIKE 'workflow%'
   OR action LIKE 'workflow_file%'
   OR action = 'workflows.approve_workflow_job'
   OR action = 'workflows.cancel_workflow_run'
   OR action = 'workflows.completed_workflow_run'
   OR action = 'workflows.created_workflow_run'
   OR action = 'workflows.delete_workflow_run'
   OR action = 'workflows.prepared_workflow_job')

  AND receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC
