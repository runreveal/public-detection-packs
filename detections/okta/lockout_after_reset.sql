WITH account_lockouts AS (
  SELECT
    eventTime as lockout_time,
    actor.alternateID as user_id,
    actor.displayName as user_name,
    srcIP as client_ip,
    srcASCountryCode as country,
    outcome as result
  FROM okta_logs
  WHERE eventType = 'user.account.lock'
    AND eventTime >= ({from:DateTime} - toIntervalMinute(60))
),
password_resets AS (
  SELECT
    eventTime as reset_time,
    actor.alternateID as user_id,
    actor.displayName as user_name,
    srcIP as client_ip,
    srcASCountryCode as country,
    outcome as result,
    eventType
  FROM okta_logs
  WHERE eventType IN ('user.account.reset_password', 'system.email.password_reset.sent_message')
    AND eventTime  >= ({from:DateTime} - toIntervalMinute(60))
)
SELECT
  l.lockout_time,
  r.reset_time,
  l.user_id,
  l.user_name,
  l.client_ip as lockout_ip,
  r.client_ip as reset_ip,
  l.country as lockout_country,
  r.country as reset_country,
  l.result as lockout_result,
  r.result as reset_result,
  r.eventType as reset_event_type
FROM account_lockouts l
JOIN password_resets r 
  ON l.user_id = r.user_id
  AND r.reset_time > l.lockout_time
  AND r.reset_time <= l.lockout_time + toIntervalMinute(60)