SELECT
    JSONExtractArrayRaw(JSONExtractArrayRaw(rawLog, 'events')[1], 'parameters') AS parameters,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x, 'name') = 'DOMAIN_NAME'), parameters)[1], 'value') AS trusted_domain,
    *
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND (eventName = 'ADD_TRUSTED_DOMAINS')
;

