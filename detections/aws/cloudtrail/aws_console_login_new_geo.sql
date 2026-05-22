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
    recent."userIdentity.userName",
    recent."userIdentity.arn",
    recent."userIdentity.type",
    recent.srcIP,
    recent.srcASCountryCode,
    recent.srcASOrganization,
    recent.srcASNumber,
    recent.eventTime,
    recent.awsRegion,
    recent.userAgent
FROM aws_cloudtrail_logs AS recent
INNER JOIN baseline_countries ON baseline_countries.userName = recent."userIdentity.userName"
WHERE recent.receivedAt >= {from:DateTime}
  AND recent.receivedAt < {to:DateTime}
  AND recent.eventName = 'ConsoleLogin'
  AND JSONExtractString(recent.responseElements, 'ConsoleLogin') = 'Success'
  AND recent.srcASCountryCode != ''
  AND recent."userIdentity.userName" != ''
  AND NOT has(baseline_countries.seenCountries, recent.srcASCountryCode)
