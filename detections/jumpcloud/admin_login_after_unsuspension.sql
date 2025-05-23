WITH admin_unsuspension_events AS (
    SELECT
        timestamp,
        initiated_by.id as admin_id,
        initiated_by.username,
        initiated_by.email
    FROM jumpcloud_events
    WHERE eventtype = 'admin_unsuspended'
      AND timestamp >= (receivedAt >= {to:DateTime} - INTERVAL {interval:Int64} DAY)
),
admin_auth_events AS (
    SELECT
        timestamp,
        initiated_by.id as admin_id,
        initiated_by.username,
        initiated_by.email,
        eventtype
    FROM jumpcloud_events
    WHERE eventtype IN (
        'admin_login_attempt',
        'admin_password_change',
        'admin_password_reset_request',
        'admin_totp_disable',
        'admin_privilege_grant'
    )
      AND timestamp >= (receivedAt >= {to:DateTime} - INTERVAL {interval:Int64} DAY)
)
SELECT
    ae.timestamp as admin_auth_time,
    ue.timestamp as admin_unsuspension_time,
    ae.admin_id,
    ae.username,
    ae.email,
    ae.eventtype as admin_auth_event_type,
    dateDiff('minute', ue.timestamp, ae.timestamp) as minutes_after_unsuspension
FROM admin_auth_events ae
INNER JOIN admin_unsuspension_events ue
    ON ae.admin_id = ue.admin_id
WHERE ae.timestamp > ue.timestamp
  AND ae.timestamp <= ue.timestamp + INTERVAL 1 HOUR
ORDER BY ae.timestamp DESC
