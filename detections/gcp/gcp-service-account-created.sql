SELECT
    *
FROM
    gcp_logs
WHERE
    receivedAt > {from :DateTime }
    AND receivedAt < {to :DateTime }
    AND arrayExists(x -> JSONExtractString(x, 'permission') IN['iam.serviceAccountKeys.create', 'iam.serviceAccounts.create'], authorizationInfo)
    AND arrayExists(x -> JSONExtractString(x, 'granted') = 'true', authorizationInfo);

