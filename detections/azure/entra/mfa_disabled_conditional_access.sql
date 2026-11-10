SELECT *
FROM
(
    SELECT
        eventTime,
        eventID,
        srcIP,
        actor['email'] AS initiatedBy,
        -- The policy is logged as one modified property whose old and new
        -- values are the full serialized policy JSON.
        arrayFirst(
            x -> position(x.2, 'grantControls') > 0 OR position(x.3, 'grantControls') > 0,
            arrayFlatten(
                arrayMap(x -> x.1,
                    JSONExtract(
                        JSON_QUERY(rawLog, '$.properties.targetResources[*]'),
                        'Array(Tuple(modifiedProperties Array(Tuple(displayName String, oldValue String, newValue String))))'
                    )
                )
            )
        ) AS changedProp,
        JSONExtract(changedProp.2, 'grantControls', 'builtInControls', 'Array(String)') AS oldControls,
        JSONExtract(changedProp.3, 'grantControls', 'builtInControls', 'Array(String)') AS newControls,
        rawLog
    FROM runreveal_logs
    WHERE sourceType = 'aad'
        AND eventName = 'Update conditional access policy'
        AND receivedAt >= {from:DateTime}
        AND receivedAt <= {to:DateTime}
        AND JSONExtractString(rawLog, 'properties', 'result') = 'success'
)
WHERE has(oldControls, 'mfa') AND NOT has(newControls, 'mfa')
;
