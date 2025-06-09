WITH disabledUsers AS
    (
        SELECT
            disabledTime,
            performedBy,
            targetUser
        FROM
        (
            SELECT
                eventTime AS disabledTime,
                performedBy,
                targetUser,
                groupArray(recentEvent) OVER (PARTITION BY targetUser, groupEvent) AS recentGroup,
                recentEvent,
                earliestGroupEvent,
                groupEvent
            FROM
            (
                SELECT
                    eventTime,
                    `actor.alternateID` AS performedBy,
                    eventType,
                    JSONExtractString(arrayJoin(target), 'alternateId') AS targetUser,
                    multiIf(eventType IN ('user.lifecycle.activate', 'user.lifecycle.create'), 1, 0) AS groupEvent,
                    row_number() OVER (PARTITION BY targetUser ORDER BY eventTime DESC) AS recentEvent,
                    row_number() OVER (PARTITION BY targetUser, groupEvent ORDER BY eventTime ASC) AS earliestGroupEvent
                FROM okta_logs
                WHERE ((eventTime >= ({from:DateTime} - toIntervalDay(90))) AND (eventTime <= {to:DateTime})) AND (eventType IN ('user.lifecycle.delete.initiated', 'user.lifecycle.activate', 'user.lifecycle.create', 'user.lifecycle.deactivate', 'user.lifecycle.suspend'))
            )
        )
        WHERE (groupEvent = 0) AND (earliestGroupEvent = 1) AND has(recentGroup, 1)
    )
SELECT
    disabledUsers.disabledTime,
    disabledUsers.performedBy AS disabledBy,
    eventTime,
    eventName,
    sourceType,
    actor,
    srcIP,
    srcASOrganization,
    srcASCountryCode,
    srcLatitude,
    srcLongitude
FROM runreveal_logs
INNER JOIN disabledUsers ON (runreveal_logs.actor['email']) = disabledUsers.targetUser
WHERE ((runreveal_logs.actor['email']) != '') AND (runreveal_logs.eventTime > disabledUsers.disabledTime) AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
;

