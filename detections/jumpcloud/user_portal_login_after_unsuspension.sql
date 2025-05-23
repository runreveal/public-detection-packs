WITH unsuspension_events AS (
    SELECT
        timestamp,
        initiated_by.id as user_id,
        initiated_by.username,
        initiated_by.email
    FROM jumpcloud_events
    WHERE eventtype = 'user_unsuspended'
      AND timestamp >= (receivedAt >= {to:DateTime} - INTERVAL {interval:Int64} DAY)
),
login_events AS (
    SELECT
        timestamp,
        initiated_by.id as user_id,
        initiated_by.username,
        initiated_by.email,
        eventtype
    FROM jumpcloud_events
    WHERE eventtype IN (
        'user_password_change',
        'user_password_reset_request',
        'user_lockout',
        'user_suspended'
    )
    AND timestamp >= (receivedAt >= {to:DateTime} - INTERVAL {interval:Int64} DAY)
)
SELECT
    le.timestamp as login_time,
    ue.timestamp as unsuspension_time,
    le.user_id,
    le.username,
    le.email,
    le.eventtype as login_event_type,
    dateDiff('minute', ue.timestamp, le.timestamp) as minutes_after_unsuspension
FROM login_events le
INNER JOIN unsuspension_events ue
    ON le.user_id = ue.user_id
WHERE le.timestamp > ue.timestamp
  AND le.timestamp <= ue.timestamp + INTERVAL 1 HOUR
ORDER BY le.timestamp DESC
