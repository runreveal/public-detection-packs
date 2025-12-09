SELECT *
FROM aws_cloudtrail_logs
WHERE
    eventSource = 'cloudfront.amazonaws.com'
    AND eventName IN ('CreateDistribution', 'CreateDistributionWithTags')
    AND errorCode = ''
    AND requestParameters LIKE '%customOriginConfig%'
    AND (receivedAt >= {from:DateTime})
    AND (receivedAt <= {to:DateTime})
;
