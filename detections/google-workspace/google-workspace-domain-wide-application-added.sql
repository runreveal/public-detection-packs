SELECT *
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND (eventName = 'ADD_APPLICATION') AND arrayExists(x -> (JSONExtractString(x, 'type') = 'DOMAIN_SETTINGS'), JSONExtractArrayRaw(rawLog, 'events'))
LIMIT 1 BY JSONExtractString(JSONExtractArrayRaw(JSONExtractArrayRaw(rawLog, 'events')[1], 'parameters')[1], 'value')
;

