SELECT
    *,
    length(eventNames) AS newEventNameCount
FROM
(
    WITH arns_and_events AS
        (
            SELECT DISTINCT
                `userIdentity.accessKeyId` AS accessKeyId,
                groupUniqArray(eventName) AS eventNames
            FROM aws_cloudtrail_logs
            WHERE ((receivedAt >= ({from:DateTime} - toIntervalDay({window:UInt32}))) AND (receivedAt <= {from:DateTime})) AND (accessKeyId LIKE 'AKIA%')
            GROUP BY accessKeyId
        )
    SELECT
        `userIdentity.accessKeyId` AS accessKeyId,
        `userIdentity.userName`,
        srcIP,
        groupUniqArray(eventName) AS eventNames,
        groupUniqArrayArray(resources)
    FROM aws_cloudtrail_logs
    LEFT JOIN arns_and_events ON arns_and_events.accessKeyId = accessKeyId
    WHERE ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime})) AND (eventName != '') AND (accessKeyId LIKE 'AKIA%') AND (NOT has(arns_and_events.eventNames, eventName))
    GROUP BY
        accessKeyId,
        `userIdentity.userName`,
        srcIP
)
WHERE length(eventNames) > {eventLimit:UInt32}
;

