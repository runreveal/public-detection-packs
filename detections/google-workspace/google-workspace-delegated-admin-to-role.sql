SELECT *
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND (eventName = 'CREATE_ROLE') AND (rawLog LIKE '%DELEGATED_ADMIN_SETTINGS%')
;

