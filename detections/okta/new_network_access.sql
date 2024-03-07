WITH networkVisit as (
    select
      DISTINCT `actor.alternateID` user,
      groupUniqArray(srcASOrganization) asorgs 
    from okta_logs
    WHERE eventTime BETWEEN {from:DateTime} - toIntervalDay({window:UInt32}) AND {from:DateTime}
    GROUP BY user
  )
  SELECT
    map('email', actor.alternateID) actor,
    `actor.alternateID` as user,
    srcASOrganization,
    srcIP,
    asorgs previousVisits,
    count(*) eventCount from okta_logs
  LEFT OUTER JOIN networkVisit ON networkVisit.user = user
  WHERE okta_logs.receivedAt BETWEEN {from:DateTime} AND {to:DateTime}
  AND `actor.type` = 'User'
  AND okta_logs.srcASOrganization IS NOT NULL
  AND NOT has({ignoreNetworksByAS:Array(UInt32)}, okta_logs.srcASNumber)
  AND networkVisit.user <> ''
  AND NOT has(networkVisit.asorgs, okta_logs.srcASOrganization)
  GROUP BY user, srcASOrganization, networkVisit.user, asorgs, srcIP
  ORDER BY eventCount DESC, user, srcASOrganization