SELECT fails.*
FROM
(
    SELECT DISTINCT
        eventTime,
        actor['email'] AS user,
        srcIP,
        JSONExtractInt(rawLog, 'resultType') AS resultID,
        JSONExtractString(rawLog, 'resultDescription') AS resultDesc,
        rawLog
    FROM runreveal_logs
    WHERE ((tags['category']) = 'SignInLogs') AND (eventName = 'Sign-in activity') AND (sourceType = 'aad') AND (JSONExtractInt(rawLog, 'resultType') != 0) AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
) AS fails
LEFT JOIN
(
    SELECT
        actor['email'] AS user,
        groupUniqArray(srcIP) AS ips
    FROM runreveal_logs
    WHERE ((tags['category']) = 'SignInLogs') AND (eventName = 'Sign-in activity') AND (sourceType = 'aad') AND (JSONExtractInt(rawLog, 'resultType') = 0) AND ((receivedAt >= ({from:DateTime} - toIntervalDay(30))) AND (receivedAt <= {from:DateTime}))
    GROUP BY user
) AS success ON fails.user = success.user
WHERE (NOT has(ips, srcIP)) AND (length(ips) > 0) AND (JSONExtractInt(rawLog, 'resultType') IN (50053))
;

