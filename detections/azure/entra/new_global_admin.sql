SELECT
    eventTime,
    eventID,
    srcIP,
    srcASOrganization,
    srcASCountryCode,
    srcLatitude,
    srcLongitude,
    initiatedBy,
    assignedUser,
    role
FROM
(
    SELECT
        eventTime,
        eventID,
        srcIP,
        srcASOrganization,
        srcASCountryCode,
        srcLatitude,
        srcLongitude,
        actor['email'] AS initiatedBy,
        arrayFirst(x -> ((x.1) = 'User'), JSONExtract(JSON_QUERY(rawLog, '$.properties.targetResources[*]'), 'Array(Tuple(type String, userPrincipalName String, modifiedProperties Array(Tuple(displayName String, newValue String))))')) AS userVals,
        userVals.2 AS assignedUser,
        replaceRegexpAll(arrayFirst(x -> ((x.1) = 'Role.DisplayName'), userVals.3).2, concat('^[', regexpQuoteMeta('"'), ']+|[', regexpQuoteMeta('"'), ']+$'), '') AS role,
        rawLog
    FROM runreveal_logs
    WHERE (eventName = 'Add member to role') AND (sourceType = 'aad') AND (JSONExtractString(rawLog, 'properties', 'operationType') = 'Assign') AND (JSONExtractString(rawLog, 'properties', 'result') = 'success') AND (role IN ({roles:Array(String)})) AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
)
;

