select * from cloudtrail_logs where eventName in ('UpdateAccessKey',
  'CreateAccessKey', 'DeleteAccessKey') and receivedAt BETWEEN {from:DateTime} AND {to:DateTime}