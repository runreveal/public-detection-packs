SELECT *
FROM
(
    SELECT
        github_prs.eventName,
        pr_link,
        github_prs.pr_id,
        pr_reviews.pr_id,
        pr_reviews.review_id,
        actor['username'] as username
    FROM
    (
        SELECT
            * EXCEPT(rawLog),
            JSONExtractInt(rawLog, 'pull_request', 'id') AS pr_id,
            JSONExtractString(rawLog, 'pull_request', 'html_url') AS pr_link,
            actor['username'] as username
        FROM runreveal_logs
        WHERE (sourceType = 'github-webhook') AND ((eventName = 'pull_request') AND (JSONExtractString(rawLog, 'action') = 'closed') AND (JSONExtractBool(rawLog, 'pull_request', 'merged') = true)) AND (receivedAt > (now() - toIntervalMinute(15)))
    ) AS github_prs
    LEFT JOIN
    (
        SELECT
            *,
            JSONExtractInt(rawLog, 'pull_request', 'id') AS pr_id,
            JSONExtractInt(rawLog, 'review', 'id') AS review_id,
            actor['username'] as username
        FROM runreveal_logs
        WHERE (sourceType = 'github-webhook') AND ((eventName = 'pull_request_review') AND (JSONExtractString(rawLog, 'action') = 'submitted') AND (JSONExtractString(rawLog, 'review', 'state') = 'approved')) AND (receivedAt > (now() - toIntervalDay(30)))
    ) AS pr_reviews ON github_prs.pr_id = pr_reviews.pr_id
)
WHERE review_id = 0
;

