WITH disabledUsers AS

  (SELECT disabledTime, performedBy, targetUser
      FROM (
  SELECT eventTime disabledTime, performedBy, targetUser,
  groupArray(recentEvent) OVER (PARTITION BY targetUser, groupEvent)
  recentGroup

  ,recentEvent, earliestGroupEvent, groupEvent

  FROM

  (select eventTime, `actor.alternateID` performedBy, eventType,
                  JSONExtractString(arrayJoin(target), 'alternateId') as targetUser,
                  case when eventType IN ('user.lifecycle.activate', 'user.lifecycle.create') THEN 1
                      else 0 END groupEvent,
                  row_number() OVER (PARTITION BY targetUser ORDER BY eventTime desc) recentEvent,
                  row_number() OVER (PARTITION BY targetUser, groupEvent ORDER BY eventTime) earliestGroupEvent
  from okta_logs where eventTime BETWEEN {from:DateTime} - INTERVAL 90 DAY AND
  {to:DateTime}

  AND eventType
          IN
  (

  'user.lifecycle.delete.initiated',

  'user.lifecycle.activate',

  'user.lifecycle.create',

  'user.lifecycle.deactivate',

  'user.lifecycle.suspend')
      )) WHERE groupEvent = 0 and earliestGroupEvent = 1 and has(recentGroup, 1))
  SELECT disabledUsers.disabledTime, disabledUsers.performedBy disabledBy,
  eventTime, eventName, sourceType, actor['email'] user, srcIP,
  srcASOrganization, srcASCountryCode, srcLatitude, srcLongitude

  FROM runreveal_logs inner join disabledUsers on
  runreveal_logs.actor['email'] = disabledUsers.targetUser

  WHERE  runreveal_logs.actor['email'] <> '' AND
      runreveal_logs.eventTime > disabledUsers.disabledTime and receivedAt BETWEEN {from:DateTime} AND {to:DateTime};