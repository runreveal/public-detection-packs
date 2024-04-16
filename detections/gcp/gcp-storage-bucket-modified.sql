SELECT * from gcp_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
and methodName != 'storage.buckets.create' and methodName like 'storage.buckets.%'
