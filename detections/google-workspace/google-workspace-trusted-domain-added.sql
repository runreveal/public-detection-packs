SELECT
  JSONExtractArrayRaw(arrayElement(JSONExtractArrayRaw(rawLog, 'events'), 1), 'parameters') as parameters,
  JSONExtractString(arrayElement(arrayFilter(x->JSONExtractString(x, 'name') = 'DOMAIN_NAME', parameters), 1), 'value') as trusted_domain,
  *
from google_workspace_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
and eventName='ADD_TRUSTED_DOMAINS'

