SELECT * from gcp_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
AND methodName = 'storage.buckets.create'

