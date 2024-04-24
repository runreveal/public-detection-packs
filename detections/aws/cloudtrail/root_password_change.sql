SELECT *
FROM aws_cloudtrail_logs
WHERE (eventName = 'PasswordUpdated') AND (`userIdentity.type` = 'Root') AND (JSONExtractString(responseElements, 'PasswordUpdated') = 'Success') AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
;

