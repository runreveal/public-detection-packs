SELECT *
FROM gcp_logs
WHERE (receivedAt > {from:DateTime }) AND (receivedAt < {to:DateTime }) AND arrayExists(x -> (((JSONExtractString(x, 'permission') != 'iam.serviceAccountKeys.create') AND (JSONExtractString(x, 'permission') LIKE 'iam.serviceAccountKeys.%')) OR ((JSONExtractString(x, 'permission') != 'iam.serviceAccounts.create') AND (JSONExtractString(x, 'permission') LIKE 'iam.serviceAccounts.%'))), authorizationInfo) AND arrayExists(x -> (JSONExtractString(x, 'granted') = 'true'), authorizationInfo)
;

