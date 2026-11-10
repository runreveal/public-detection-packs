SELECT
    `userIdentity.arn`,
    any(`userIdentity.type`) AS identityType,
    any(`userIdentity.accountId`) AS accountId,
    uniqExactIf(instanceId, instanceId != '') AS instance_count,
    groupUniqArrayIf(50)(instanceId, instanceId != '') AS instance_ids,
    uniqExactIf(eventID, dynamicTarget) AS dynamic_target_commands,
    groupUniqArrayIf(10)(targets, dynamicTarget) AS dynamic_targets,
    groupUniqArray(10)(documentName) AS documents,
    groupUniqArray(5)(srcIP) AS src_ips,
    uniqExact(eventID) AS command_count,
    min(eventTime) AS first_event,
    max(eventTime) AS last_event
FROM
(
    SELECT
        `userIdentity.arn`,
        `userIdentity.type`,
        `userIdentity.accountId`,
        eventID,
        srcIP,
        eventTime,
        JSONExtractString(requestParameters, 'documentName') AS documentName,
        JSONExtractRaw(requestParameters, 'targets') AS targets,
        JSONExtractArrayRaw(requestParameters, 'targets') AS targetList,
        arrayConcat(
            JSONExtract(requestParameters, 'instanceIds', 'Array(String)'),
            arrayFlatten(arrayMap(
                t -> JSONExtract(t, 'values', 'Array(String)'),
                arrayFilter(t -> JSONExtractString(t, 'key') = 'InstanceIds', targetList)
            ))
        ) AS explicitInstanceIds,
        -- Tag or resource-group targets resolve to instances server-side, so
        -- one call can reach the whole fleet without listing any instance ID.
        arrayExists(t -> JSONExtractString(t, 'key') != 'InstanceIds', targetList) AS dynamicTarget,
        arrayJoin(if(empty(explicitInstanceIds), [''], explicitInstanceIds)) AS instanceId
    FROM aws_cloudtrail_logs
    WHERE (receivedAt >= {from:DateTime})
        AND (receivedAt < {to:DateTime})
        AND eventSource = 'ssm.amazonaws.com'
        AND eventName = 'SendCommand'
        AND errorCode = ''
        -- Known automation (e.g. NAT gateway health-check Lambdas) legitimately
        -- fans a single SendCommand run out across many instances on a schedule.
        -- Add the role/session name fragment to excludeArnPatterns to quiet it.
        AND NOT arrayExists(p -> (`userIdentity.arn` LIKE p), {excludeArnPatterns:Array(String)})
)
GROUP BY `userIdentity.arn`
HAVING (instance_count >= {threshold:UInt32}) OR (dynamic_target_commands > 0)
ORDER BY instance_count DESC
