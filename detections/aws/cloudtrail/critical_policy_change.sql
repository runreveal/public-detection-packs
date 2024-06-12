SELECT *
FROM aws_cloudtrail_logs
WHERE (eventName IN ('AuthorizeSecurityGroupIngress', 'PutKeyPolicy', 'PutBucketPolicy', 'UpdateAssumeRolePolicy', 'AttachUserPolicy', 'PutRolePolicy', 'PutGroupPolicy')) AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
;

