SELECT
    actor,
    max(count) AS failedAttempts,
    max(eventTime) AS eventTime,
    max(receivedAt) AS receivedAt
FROM
(
    SELECT
        *,
        SUM(1) OVER w AS count
    FROM okta_logs
    WHERE (eventType = 'user.session.start') AND (outcome = 'FAILURE') AND (receivedAt >= ({from:DateTime} - toIntervalMinute(40)))
    WINDOW w AS (PARTITION BY actor ORDER BY eventTime ASC RANGE BETWEEN 1200 PRECEDING AND CURRENT ROW)
)
WHERE count >= 3
GROUP BY actor
HAVING (receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime})
;

