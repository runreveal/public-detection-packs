SELECT *
FROM gcp_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime})
  AND arrayExists(x ->
        (JSONExtractString(x, 'granted') = 'true')
        AND (JSONExtractString(x, 'permission') IN (
          'iam.serviceAccounts.getAccessToken',
          'iam.serviceAccounts.signBlob',
          'iam.serviceAccounts.signJwt',
          'iam.serviceAccounts.implicitDelegation'
        )), authorizationInfo)
  -- Service accounts routinely call GenerateAccessToken/SignJwt on
  -- themselves to mint their own short-lived credentials; this is normal
  -- GCP workload-identity behavior and dominates this permission's volume.
  -- Scope to human/interactive callers, where impersonating a service
  -- account for one of these privileged actions is a much rarer and more
  -- meaningful signal. Tune with allowedPrincipals for expected tooling.
  AND (principalEmail NOT LIKE '%.gserviceaccount.com')
  AND (principalEmail != '')
  AND (NOT arrayExists(p -> principalEmail LIKE p, {allowedPrincipals:Array(String)}))
;
