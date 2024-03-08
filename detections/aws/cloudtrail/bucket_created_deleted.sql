select * from cloudtrail_logs where eventName in ('CreateBucket',
  'DeleteBucket') and receivedAt BETWEEN {from:DateTime} AND {to:DateTime}