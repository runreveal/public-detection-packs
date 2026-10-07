WITH auth_failures AS (
  SELECT
    eventTime,
    actor.alternateID as user,
    srcIP as client_ip,
    eventType,
    client.userAgent as user_agent,
    outcome as result,
    authenticationContext as auth_context
  FROM okta_logs
  WHERE eventType IN ('user.session.start', 'user.authentication.verify')
    AND outcome = 'FAILURE'
    AND eventTime >= (eventTime >= ({from:DateTime} - toIntervalMinute(2))
)
SELECT
  min(eventTime) as first_failure,
  max(eventTime) as last_failure,
  user,
  client_ip,
  count(*) as failure_count,
  groupArray(eventType) as event_types,
  groupArray(user_agent) as user_agents,
  groupArray(auth_context) as auth_contexts
FROM auth_failures
GROUP BY user, client_ip
HAVING count(*) >= 10