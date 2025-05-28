SELECT
  `actor.alternateID` as actor_email,
  `actor.displayName` as actor_name,
  eventName as rate_limit_event,
  JSONExtractString(rawLog, 'client', 'userAgent') as user_agent,
  srcIP as source_ip,
  JSONExtractString(rawLog, 'client', 'geographicalContext', 'country') as country,
  JSONExtractString(rawLog, 'client', 'geographicalContext', 'city') as city,
  outcome as result,
  *
FROM
  okta_logs
WHERE
  (
    eventName LIKE 'app.oauth2.client_id_rate_limit_warning%'
    OR eventName LIKE 'application.integration.rate_limit_exceeded%'
    OR eventName LIKE 'system.client.rate_limit.%'
    OR eventName LIKE 'system.client.concurrency_rate_limit.%'
    OR eventName LIKE 'system.operation.rate_limit.%'
    OR eventName LIKE 'system.org.rate_limit.%'
    OR eventName = 'core.concurrency.org.limit.violation'
  )
  AND eventName LIKE '%violation%'
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime} 