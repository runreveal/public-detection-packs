SELECT *
FROM cloudtrail_logs
WHERE (eventName IN ('UpdateAccessKey', 'CreateAccessKey', 'DeleteAccessKey')) AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
;

