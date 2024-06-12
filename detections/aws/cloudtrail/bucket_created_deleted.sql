SELECT *
FROM aws_cloudtrail_logs
WHERE (eventName IN ('CreateBucket', 'DeleteBucket')) AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
;

