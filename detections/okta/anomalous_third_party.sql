WITH eventTypesCalled as (
    select 
    DISTINCT `actor.displayName` user,
    groupUniqArray(eventType) eventTypes 
    from okta_logs
    WHERE
    eventTime BETWEEN {from:DateTime} - toIntervalDay({window:UInt32}) AND {from:DateTime}
    and actor.type='PublicClientApp'
    GROUP BY user
)
SELECT
    map('name', actor.displayName) as actor,
    `actor.displayName` as user,
    eventType,
    srcIP,
    eventTypes previousVisits,
    count(*) eventCount
from okta_logs
LEFT OUTER JOIN eventTypesCalled ON eventTypesCalled.user = user
WHERE okta_logs.receivedAt BETWEEN {from:DateTime} AND {to:DateTime}
AND actor.type = 'PublicClientApp'
AND okta_logs.eventType IS NOT NULL
AND eventTypesCalled.user <> ''
AND NOT has(eventTypesCalled.eventTypes, okta_logs.eventType)
GROUP BY user, eventType, eventTypesCalled.user, srcIP, eventTypes
ORDER BY eventCount DESC, user, eventType