SELECT * from gcp_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
and arrayExists(
    x -> JSONExtractString(x, 'permission') = 'iam.serviceAccountKeys.create',
    authorizationInfo
);

