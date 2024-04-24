SELECT
    max(eventTime) AS eventTime,
    max(receivedAt) AS receivedAt,
    actor,
    srcIP,
    srcASCountryCode,
    count(*) AS downloadCnt
FROM logs
WHERE (sourceType = 'gsuite') AND (eventName = 'download') AND ((actor['email']) != '') AND ((logs.receivedAt >= {from:DateTime}) AND (logs.receivedAt <= {to:DateTime}))
GROUP BY
    actor,
    srcIP,
    srcASCountryCode
HAVING downloadCnt >= toInt64({threshold:String})
ORDER BY downloadCnt DESC
;

