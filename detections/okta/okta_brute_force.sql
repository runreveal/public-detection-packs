SELECT actor, max(count) as failedAttempts, max(eventTime) as eventTime, max(receivedAt) as receivedAt
    FROM (
SELECT
    *,
    SUM(1) OVER w AS count
FROM
    okta_logs
WHERE eventType='user.session.start' and outcome='FAILURE' AND
    eventTime >= {from:DateTime} - toIntervalMinute(40)  -- Filter records from the past 90 minutes
WINDOW
    w AS (PARTITION BY actor ORDER BY eventTime RANGE BETWEEN (20 * 60) PRECEDING AND CURRENT ROW))
WHERE count >= 3
GROUP BY actor
HAVING receivedAt BETWEEN {from:DateTime} AND {to:DateTime}