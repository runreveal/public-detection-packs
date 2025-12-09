SELECT
    actor['alternateId'] AS user_email,
    client['ipAddress'] AS source_ip,
    count(*) AS app_access_count,
    count(DISTINCT target) AS unique_apps
FROM
    runreveal.logs
WHERE
    sourceType = 'okta'
    AND eventName IN ('application.read', 'application.lifecycle.activate', 'app.generic.provision.assign_user_to_app')
    AND receivedAt >= {from:DateTime}
    AND receivedAt < {to:DateTime}
GROUP BY
    user_email,
    source_ip
HAVING
    unique_apps >= {threshold:UInt32}
