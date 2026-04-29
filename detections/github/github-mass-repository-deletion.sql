SELECT
    actor_id,
    COUNT(DISTINCT repo) AS deleted_repos,
    groupArray(repo) AS repositories,
    MIN(eventTime) AS first_deletion,
    MAX(eventTime) AS last_deletion,
    MAX(receivedAt) AS last_received_at
FROM github_logs
WHERE
    action = 'repo.destroy'
    AND receivedAt >= ({from:DateTime} - toIntervalMinute({window:UInt32}))
    AND receivedAt >= {from:DateTime}
    AND receivedAt <= {to:DateTime}
GROUP BY actor_id
HAVING deleted_repos >= {threshold:UInt32}
ORDER BY deleted_repos DESC
