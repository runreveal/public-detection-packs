SELECT DISTINCT on (
  JSONExtractString(arrayElement(JSONExtractArrayRaw(arrayElement(JSONExtractArrayRaw(rawLog, 'events'), 1), 'parameters'), 1), 'value')
) *
FROM google_workspace_logs 
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
and eventName='ADD_APPLICATION'
and arrayExists(
  x -> JSONExtractString(x, 'type')='DOMAIN_SETTINGS',
  JSONExtractArrayRaw(rawLog, 'events')
)

