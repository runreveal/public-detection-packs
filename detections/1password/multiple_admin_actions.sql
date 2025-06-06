WITH adminActions AS
    (
        SELECT
            `actor.email` AS user,
            eventName,
            receivedAt,
            COUNT(*) OVER (PARTITION BY user) AS actionsInWindow
        FROM one_password_logs
        WHERE (eventName IN ('create', 'delete', 'update', 'grant', 'revoke', 'suspend', 'activate', 'beginr', 'reactive')) AND (receivedAt > ({from:DateTime} - toIntervalMinute(120))) AND (receivedAt <= {to:DateTime}) AND (user NOT LIKE '%1passwordserviceaccounts.com')
    )
SELECT
    user,
    COUNT(*) AS totalActions,
    MAX(actionsInWindow) AS maxActionsInWindow,
    MIN(receivedAt) AS firstAction,
    MAX(receivedAt) AS lastAction,
    groupArrayDistinct(eventName) AS actionTypes
FROM adminActions
WHERE actionsInWindow > 10
GROUP BY user
HAVING COUNT(*) > 10
ORDER BY
    maxActionsInWindow DESC,
    totalActions DESC
