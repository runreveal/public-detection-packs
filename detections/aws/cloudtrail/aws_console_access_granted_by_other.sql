SELECT *
FROM aws_cloudtrail_logs
WHERE (eventSource = 'iam.amazonaws.com')
    AND (eventName = 'CreateLoginProfile')
    AND (errorCode = '')
    AND (NOT endsWith(`userIdentity.arn`, concat('/', JSONExtractString(requestParameters, 'userName'))))
    AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
;
