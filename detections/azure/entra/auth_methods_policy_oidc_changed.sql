SELECT *
FROM
(
    SELECT
        eventTime,
        eventID,
        srcIP,
        actor['email'] AS initiatedBy,
        arrayFlatten(
            arrayMap(x -> x.1,
                JSONExtract(
                    JSON_QUERY(rawLog, '$.properties.targetResources[*]'),
                    'Array(Tuple(modifiedProperties Array(Tuple(displayName String, oldValue String, newValue String))))'
                )
            )
        ) AS allModifiedProperties,
        arrayFirst(x -> position(x.2, 'discoveryUrl') > 0 OR position(x.3, 'discoveryUrl') > 0, allModifiedProperties) AS changedProp,
        rawLog
    FROM runreveal_logs
    WHERE sourceType = 'aad'
        AND position(lower(eventName), 'authentication methods policy update') > 0
        AND receivedAt >= {from:DateTime}
        AND receivedAt <= {to:DateTime}
        AND JSONExtractString(rawLog, 'properties', 'result') = 'success'
)
WHERE changedProp.1 != '' AND changedProp.2 != changedProp.3
;
