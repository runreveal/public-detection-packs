SELECT *
FROM logs
WHERE (sourceType = 'aad') AND ((tags['category']) = 'SignInLogs') AND (JSONExtractUInt(rawLog, 'properties.status.errorCode') = 500121) AND ((receivedAt >= {from:DateTime }) AND (receivedAt <= {to:DateTime }))
;

