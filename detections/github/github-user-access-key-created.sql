SELECT
  receivedAt, eventTime, eventName, id, sourceType,
  srcIP, srcASCountryCode, srcASNumber, srcASOrganization, srcCity,
  actor, resources, serviceName, tags,
  -- github-specific
  action, org, org_id, repo, user, user_id,
  actor_country_code, hashed_token, token_id, token_scopes,
  programmatic_access_type, external_identity_nameid
FROM
github_logs
WHERE action IN (
 'public_key.create'
) AND
receivedAt > {from:DateTime} AND receivedAt <= {to:DateTime}
ORDER BY receivedAt DESC
