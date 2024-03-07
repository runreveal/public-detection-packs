select *, length(eventNames) newEventNameCount from (
    WITH arns_and_events as (
        select
        DISTINCT `userIdentity.accessKeyId` accessKeyId,
        groupUniqArray(eventName) eventNames
        from cloudtrail_logs
        WHERE
        eventTime BETWEEN {from:DateTime} - toIntervalDay({window:UInt32}) AND
        {from:DateTime}
        AND accessKeyId like 'AKIA%'
        GROUP BY accessKeyId
    )

    SELECT
    `userIdentity.accessKeyId` accessKeyId,
    `userIdentity.userName`,
    srcIP,
    groupUniqArray(eventName) eventNames,
    groupUniqArrayArray(resources)
    from cloudtrail_logs
    LEFT OUTER JOIN arns_and_events ON arns_and_events.accessKeyId = accessKeyId
    WHERE
    receivedAt BETWEEN {from:DateTime} AND {to:DateTime}
    AND eventName!=''
    AND accessKeyId LIKE 'AKIA%'
    AND NOT has(arns_and_events.eventNames, eventName)
    GROUP BY accessKeyId,`userIdentity.userName`, srcIP
) where length(eventNames) > {eventLimit:UInt32}