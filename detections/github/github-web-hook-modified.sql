-- GitHub Unauthorized Webhook Modification Detection
-- Based on the provided Python rule

SELECT 

  CASE 
    WHEN action LIKE '%destroy' THEN 'deleted'
    WHEN action LIKE '%create' THEN 'created'
    ELSE 'modified'
  END as webhook_operation,
  -- Calculate severity based on action
  CASE 
    WHEN action LIKE '%create' THEN 'MEDIUM'
    ELSE 'INFO'
  END as severity,
  *
FROM 
  github_logs
WHERE 
  -- Match webhook-related actions only
  action LIKE 'hook.%'
  
  -- Exclude public repositories (if this field is populated)
  AND (public_repo != 'true' OR public_repo IS NULL OR repository_public != 'true' OR repository_public IS NULL)
  
  -- Exclude actions by the unito sync bot
  AND actor['email'] != 'sync-by-unito[bot]'
  
  AND receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC 