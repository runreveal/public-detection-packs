SELECT
    eventTime,
    actor['email'] AS user,
    srcIP,
    srcASOrganization,
    srcISP,
    srcCity,
    srcASCountryCode,
    srcLatitude,
    srcLongitude,
    srcISP
FROM runreveal_logs
WHERE (sourceType = 'gsuite') AND (eventName LIKE 'DOWNLOAD_USERLIST%') AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
ORDER BY eventTime DESC
;

