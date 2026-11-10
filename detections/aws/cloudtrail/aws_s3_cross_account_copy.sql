SELECT *
FROM
(
    SELECT
        *,
        arrayDistinct(
            arrayFilter(a -> a != '',
                arrayMap(x -> JSONExtractString(x, 'accountId'),
                    arrayFilter(x -> JSONExtractString(x, 'type') = 'AWS::S3::Bucket', resources)
                )
            )
        ) AS bucketAccountIds
    FROM aws_cloudtrail_logs
    WHERE (receivedAt >= {from:DateTime})
        AND (receivedAt < {to:DateTime})
        AND eventSource = 's3.amazonaws.com'
        AND eventName = 'CopyObject'
        AND errorCode = ''
)
-- CloudTrail lists both the source and destination buckets as resources
-- on a CopyObject event. More than one distinct bucket account ID means
-- the object crossed an account boundary.
WHERE length(bucketAccountIds) > 1
;
