SELECT
    actor['alternateId'] AS user_email,
    count(*) AS lookup_count,
    count(DISTINCT target) AS unique_targets
FROM
    runreveal.logs
WHERE
    sourceType = 'okta'
    AND eventName IN ('user.session.access_admin_app', 'user.lookup', 'directory.user_profile.read')
    AND receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
GROUP BY
    user_email
HAVING
    lookup_count >= {threshold:UInt32}
