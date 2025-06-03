WITH adminActions AS (
    SELECT
        `actor.email` AS user,
        actor_uuid,
        eventName,
        eventTime,
        receivedAt,
        COUNT(*) OVER (
            PARTITION BY actor_uuid 
            ORDER BY eventTime 
            RANGE BETWEEN INTERVAL 5 MINUTE PRECEDING AND CURRENT ROW
        ) AS actionsInWindow
    FROM one_password_logs
    WHERE 
        eventName IN ('create', 'delete', 'update', 'grant', 'revoke', 'suspend', 'reactive')
        AND eventTime >= ({from:DateTime} - toIntervalMinute(30))
        AND receivedAt >= {from:DateTime}
        AND receivedAt <= {to:DateTime}
        AND `actor.email` NOT LIKE '%1passwordserviceaccounts.com'
)
SELECT
    user,
    actor_uuid,
    COUNT(*) AS totalActions,
    MAX(actionsInWindow) AS maxActionsInWindow,
    MIN(eventTime) AS firstAction,
    MAX(eventTime) AS lastAction,
    MAX(receivedAt) AS receivedAt,
    groupArray(DISTINCT eventName) AS actionTypes
FROM adminActions
WHERE actionsInWindow > 10
GROUP BY user, actor_uuid
HAVING COUNT(*) > 10
ORDER BY maxActionsInWindow DESC, totalActions DESC
;