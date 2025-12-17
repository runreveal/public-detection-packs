SELECT
    eventTime,
    actor['email'] AS actor,
    JSONExtractString(rawLog, 'target', 'name') AS nodeName,
    JSONExtractBool(rawLog, 'target', 'isEphemeral') AS ephemeral
FROM tailscale_audit_logs
WHERE (eventName = 'CREATE_NODE') AND ((JSONExtractBool(rawLog, 'target', 'isEphemeral') = false) OR (JSONExtractBool(rawLog, 'target', 'isEphemeral') = {includeEphemeral:Boolean})) AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
;

