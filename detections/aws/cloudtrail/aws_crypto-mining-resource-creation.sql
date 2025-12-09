SELECT *
FROM aws_cloudtrail_logs
WHERE
    eventName = 'RunInstances'
    AND errorCode = ''
    AND (
        requestParameters LIKE '%"instanceType":"p%'
        OR requestParameters LIKE '%"instanceType":"g%'
        OR requestParameters LIKE '%"instanceType":"c%'
    )
    AND (receivedAt >= {from:DateTime})
    AND (receivedAt <= {to:DateTime})
;
