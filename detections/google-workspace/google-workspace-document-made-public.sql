SELECT
    JSONExtractArrayRaw(JSONExtractArrayRaw(rawLog, 'events')[1], 'parameters') AS parameters,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x, 'name') = 'doc_title'), parameters)[1], 'value') AS document,
    *
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND arrayExists(x -> ((JSONExtractString(x, 'name') = 'new_value') AND (x LIKE '%people_with_link%')), parameters)
;

