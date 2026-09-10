SELECT *
FROM gcp_logs
WHERE (receivedAt > {from:DateTime }) AND (receivedAt < {to:DateTime })
  -- A single authorizationInfo element must be BOTH sensitive AND granted.
  -- Checking these in two separate arrayExists() calls lets them match
  -- different elements, so an event where the sensitive permission was denied
  -- still fires as long as anything else in the array was granted.
  AND arrayExists(x ->
        (JSONExtractString(x, 'granted') = 'true')
        AND (JSONExtractString(x, 'permission') IN (
          -- key lifecycle (creation is covered by gcp-service-account-created)
          'iam.serviceAccountKeys.delete',
          'iam.serviceAccountKeys.disable',
          'iam.serviceAccountKeys.enable',
          'iam.serviceAccountKeys.upload',
          -- service account lifecycle / privilege changes
          'iam.serviceAccounts.delete',
          'iam.serviceAccounts.undelete',
          'iam.serviceAccounts.disable',
          'iam.serviceAccounts.enable',
          'iam.serviceAccounts.update',
          'iam.serviceAccounts.setIamPolicy'
        )), authorizationInfo)
  -- Google-managed service agents are the dominant false-positive source.
  AND NOT (
    (principalEmail LIKE 'service-%@%.iam.gserviceaccount.com')
    OR (principalEmail LIKE '%@cloudservices.gserviceaccount.com')
    OR (principalEmail LIKE '%@system.gserviceaccount.com')
    OR (principalEmail LIKE '%@gcp-sa-%.iam.gserviceaccount.com')
  )
;
