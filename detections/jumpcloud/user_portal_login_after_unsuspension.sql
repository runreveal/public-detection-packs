WITH unsuspension_events AS (
    SELECT
        eventTime,
        rawLog.initiated_by.username,
        sourceType
    FROM logs
    WHERE sourceType = 'jumpcloud' AND
          eventName = 'user_unsuspended' AND
          eventTime >= {to:DateTime} - INTERVAL {interval:Int64} DAY)
),
login_events AS (
    SELECT
        eventTime,
        rawLog.initiated_by.username,
        eventName
        sourceType
    FROM logs
    WHERE sourceType = 'jumpcloud' AND
          eventName IN (
        'user_password_change',
        'user_password_reset_request',
        'user_lockout',
        'user_suspended'
    ) AND
          eventTime >= (eventTime >= {to:DateTime} - INTERVAL {interval:Int64} DAY)
)
SELECT
    le.eventTime as login_time,
    ue.eventTime as unsuspension_time,
    le.username,
    le.eventName as login_event_type,
    dateDiff('minute', ue.eventTime, le.eventTime) as minutes_after_unsuspension
FROM login_events le
INNER JOIN unsuspension_events ue
    ON le.username = ue.username
WHERE le.eventTime > ue.eventTime
  AND le.eventTime <= ue.eventTime + INTERVAL 1 HOUR
ORDER BY le.eventTime DESC
