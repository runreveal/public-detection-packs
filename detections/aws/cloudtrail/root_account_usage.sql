select * from cloudtrail_logs where (userIdentity.type='Root' and
  userAgent!='AWS Internal') and receivedAt BETWEEN {from:DateTime} AND {to:DateTime}