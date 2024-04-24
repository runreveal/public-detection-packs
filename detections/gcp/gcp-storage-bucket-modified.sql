SELECT *
FROM gcp_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND (methodName != 'storage.buckets.create') AND (methodName LIKE 'storage.buckets.%')
;

