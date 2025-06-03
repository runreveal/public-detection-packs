SELECT
    `actor.email` AS user,
    COUNT(*) AS failedAttempts,
    max(eventTime) AS eventTime,
    max(receivedAt) AS receivedAt
FROM one_password_logs
WHERE 
    (eventName IN ('signin_attempt', 'user_authentication'))
    AND (`result` = 'failure' OR outcome = 'FAILURE')
    AND (eventTime >= ({from:DateTime} - toIntervalMinute(30)))
    AND (receivedAt >= {from:DateTime}) 
    AND (receivedAt <= {to:DateTime})
GROUP BY `actor.email`
HAVING COUNT(*) > 5
; 