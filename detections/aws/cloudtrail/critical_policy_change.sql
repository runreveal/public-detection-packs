select * from cloudtrail_logs where eventName in
  ('AuthorizeSecurityGroupIngress','PutKeyPolicy','PutBucketPolicy','UpdateAssumeRolePolicy','AttachUserPolicy','PutRolePolicy','PutGroupPolicy')
  and receivedAt BETWEEN {from:DateTime} AND {to:DateTime}