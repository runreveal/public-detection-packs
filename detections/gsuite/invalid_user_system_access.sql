WITH invalidUsers AS
    (
        SELECT *
        FROM
        (
            SELECT
                delete.*,
                row_number() OVER (PARTITION BY delete.userEmail ORDER BY delete.eventTime DESC) AS rnum
            FROM
            (
                SELECT
                    eventTime,
                    if(eventName = 'DELETE_USER', 'DELETED', 'SUSPENDED') AS eventType,
                    workspaceID,
                    JSONExtractString(arrayFirst(x -> (JSONExtractString(x, 'name') = 'USER_EMAIL'), JSONExtractArrayRaw(arrayFirst(x -> (JSONExtractString(x, 'type') = 'USER_SETTINGS'), JSONExtractArrayRaw(rawLog, 'events')), 'parameters')), 'value') AS userEmail
                FROM runreveal_logs
                WHERE (sourceType = 'gsuite') AND (eventName IN ('DELETE_USER', 'SUSPEND_USER')) AND ((eventTime >= ({from:DateTime} - toIntervalDay(90))) AND (eventTime <= {to:DateTime}))
            ) AS delete
            LEFT JOIN
            (
                SELECT
                    eventTime,
                    if(eventName = 'CREATE_USER', 'D', 'S') AS eventType,
                    workspaceID,
                    JSONExtractString(arrayFirst(x -> (JSONExtractString(x, 'name') = 'USER_EMAIL'), JSONExtractArrayRaw(arrayFirst(x -> (JSONExtractString(x, 'type') = 'USER_SETTINGS'), JSONExtractArrayRaw(rawLog, 'events')), 'parameters')), 'value') AS userEmail
                FROM runreveal_logs
                WHERE (sourceType = 'gsuite') AND (eventName IN ('CREATE_USER', 'UNSUSPEND_USER')) AND ((eventTime >= ({from:DateTime} - toIntervalDay(90))) AND (eventTime <= {to:DateTime}))
            ) AS create ON (delete.userEmail = create.userEmail) AND (delete.eventType = create.eventType) AND (delete.workspaceID = create.workspaceID)
            WHERE (create.userEmail IS NULL) OR (create.userEmail = '') OR (create.eventTime < delete.eventTime)
        )
        WHERE rnum = 1
    )
SELECT
    invalidUsers.eventType AS invalidatedType,
    invalidUsers.eventTime AS invalidatedTime,
    invalidUsers.userEmail,
    runreveal_logs.id,
    runreveal_logs.eventTime,
    runreveal_logs.sourceType,
    runreveal_logs.sourceID,
    runreveal_logs.eventName,
    runreveal_logs.srcIP,
    runreveal_logs.srcASOrganization,
    runreveal_logs.srcCity,
    runreveal_logs.srcASCountryCode,
    runreveal_logs.srcLatitude,
    runreveal_logs.srcLongitude,
    runreveal_logs.rawLog
FROM
(
    SELECT *
    FROM runreveal_logs
    WHERE ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime})) AND ((actor['email']) != '')
) AS runreveal_logs
INNER JOIN invalidUsers ON ((runreveal_logs.actor['email']) = invalidUsers.userEmail) AND (runreveal_logs.workspaceID = invalidUsers.workspaceID)
WHERE runreveal_logs.eventTime > invalidUsers.eventTime
;

