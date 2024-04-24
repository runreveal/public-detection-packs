SELECT *
FROM cloudtrail_logs
WHERE ((userIdentity.type = 'Root') AND (userAgent != 'AWS Internal')) AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
;

