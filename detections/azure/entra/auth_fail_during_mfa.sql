SELECT
    *
FROM
    logs
WHERE
    sourceType = 'aad'
    AND tags['category'] = 'SignInLogs'
    AND JSONExtractUInt(rawLog, 'properties.status.errorCode') == 500121
    AND receivedAt BETWEEN {from :DateTime } AND {to :DateTime };

