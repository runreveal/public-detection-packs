WITH admin_unsuspension_events AS (
    SELECT
        receivedAt,
        rawLog.initiated_by.username,
    FROM logs
    WHERE sourceType = 'jumpcloud' AND
          eventName = 'admin_unsuspended'
          receivedAt >= ({to:DateTime} - INTERVAL {interval:Int64} DAY)
),
admin_auth_events AS (
    SELECT
        receivedAt,
        rawLog.initiated_by.username,
        eventName
    FROM logs
    WHERE sourceType = 'jumpcloud' AND
          eventName IN (
            'admin_login_attempt',
            'admin_password_change',
            'admin_password_reset_request',
            'admin_totp_disable',
            'admin_privilege_grant'
          ) AND
          receivedAt >= (receivedAt >= {to:DateTime} - INTERVAL {interval:Int64} DAY)
)
SELECT
    ae.receivedAt as admin_auth_time,
    ue.receivedAt as admin_unsuspension_time,
    ae.admin_id,
    ae.username,
    ae.eventName as admin_auth_event_type,
    dateDiff('minute', ue.receivedAt, ae.receivedAt) as minutes_after_unsuspension
FROM admin_auth_events ae
INNER JOIN admin_unsuspension_events ue
    ON ae.username = ue.username
WHERE ae.receivedAt > ue.receivedAt
  AND ae.receivedAt <= (ue.receivedAt + INTERVAL 1 HOUR)
ORDER BY ae.receivedAt DESC
