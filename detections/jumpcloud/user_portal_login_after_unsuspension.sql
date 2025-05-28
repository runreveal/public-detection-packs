WITH unsuspension_events AS (
    SELECT
        receivedAt,
        rawLog.initiated_by.username,
        sourceType
    FROM logs
    WHERE sourceType = 'jumpcloud' AND
          eventName = 'user_unsuspended' AND
          receivedAt >= {to:DateTime} - INTERVAL {interval:Int64} DAY)
),
login_events AS (
    SELECT
        receivedAt,
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
          receivedAt >= (receivedAt >= {to:DateTime} - INTERVAL {interval:Int64} DAY)
)
SELECT
    le.receivedAt as login_time,
    ue.receivedAt as unsuspension_time,
    le.username,
    le.eventName as login_event_type,
    dateDiff('minute', ue.receivedAt, le.receivedAt) as minutes_after_unsuspension
FROM login_events le
INNER JOIN unsuspension_events ue
    ON le.username = ue.username
WHERE le.receivedAt > ue.receivedAt
  AND le.receivedAt <= ue.receivedAt + INTERVAL 1 HOUR
ORDER BY le.receivedAt DESC
