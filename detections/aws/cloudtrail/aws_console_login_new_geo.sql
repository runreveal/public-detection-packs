WITH baseline_countries AS (
    SELECT
        "userIdentity.userName" AS userName,
        groupUniqArray(srcASCountryCode) AS seenCountries
    FROM aws_cloudtrail_logs
    WHERE receivedAt >= ({from:DateTime} - toIntervalDay({window:UInt32}))
      AND receivedAt < {from:DateTime}
      AND eventName = 'ConsoleLogin'
      AND JSONExtractString(responseElements, 'ConsoleLogin') = 'Success'
      AND srcASCountryCode != ''
      AND "userIdentity.userName" != ''
    GROUP BY userName
)
SELECT
    current."userIdentity.userName",
    current."userIdentity.arn",
    current."userIdentity.type",
    current.srcIP,
    current.srcASCountryCode,
    current.srcASOrganization,
    current.srcASNumber,
    current.eventTime,
    current.awsRegion,
    current.userAgent
FROM aws_cloudtrail_logs current
INNER JOIN baseline_countries ON baseline_countries.userName = current."userIdentity.userName"
WHERE current.receivedAt >= {from:DateTime}
  AND current.receivedAt < {to:DateTime}
  AND current.eventName = 'ConsoleLogin'
  AND JSONExtractString(current.responseElements, 'ConsoleLogin') = 'Success'
  AND current.srcASCountryCode != ''
  AND current."userIdentity.userName" != ''
  AND NOT has(baseline_countries.seenCountries, current.srcASCountryCode)
