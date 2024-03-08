select * from aws_cloudtrail_logs
where eventName = 'PasswordUpdated'
AND `userIdentity.type` = 'Root'
AND JSONExtractString(responseElements, 'PasswordUpdated') = 'Success'
AND receivedAt BETWEEN {from:DateTime} AND {to:DateTime}