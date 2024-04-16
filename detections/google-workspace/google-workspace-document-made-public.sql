SELECT 
  JSONExtractArrayRaw(arrayElement(JSONExtractArrayRaw(rawLog, 'events'), 1), 'parameters') as parameters,
  JSONExtractString(arrayElement(arrayFilter(x->JSONExtractString(x, 'name') = 'doc_title', parameters), 1), 'value') as document,
  *
FROM google_workspace_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
AND
arrayExists(
  x->JSONExtractString(x, 'name')='new_value' AND x like '%people_with_link%',
  parameters
)
