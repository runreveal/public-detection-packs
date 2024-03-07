WITH countryVisit as (select DISTINCT `actor.alternateID` user,
groupUniqArray(srcASCountryCode) countrys from okta_logs

WHERE eventTime BETWEEN {from:DateTime} - INTERVAL 30 DAY AND
{from:DateTime}

GROUP BY user)

SELECT `actor.alternateID` as user, srcASCountryCode, countrys
previousVisits, count(*) eventCount from okta_logs

LEFT OUTER JOIN countryVisit ON countryVisit.user = user

WHERE okta_logs.receivedAt BETWEEN {from:DateTime} AND {to:DateTime}

AND okta_logs.srcASCountryCode IS NOT NULL AND `actor.type` = 'User'

AND countryVisit.user <> '' AND NOT has(countryVisit.countrys,
okta_logs.srcASCountryCode)

GROUP BY user, srcASCountryCode, countryVisit.user, countrys

ORDER BY eventCount DESC, user, srcASCountryCode;