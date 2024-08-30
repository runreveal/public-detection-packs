WITH logged_events AS (
    SELECT
        actor['email'] AS email
    FROM
        runreveal.logs
    WHERE
        sourceType = 'okta'
        AND (eventName = 'device.user.add'
             OR eventName = 'device.user.mfa.factor'
             OR eventName = 'user.account.update_password')
        AND receivedAt BETWEEN {to:DateTime} - INTERVAL 7 DAY AND {to:DateTime}
), auth_events AS (
    SELECT
        actor['email'] AS email,
        countDistinct(simpleJSONExtractRaw(JSONExtractArrayRaw(logs.rawLog,'target')[1], 'alternateId')) AS auth_count
    FROM
        runreveal.logs
    WHERE
        sourceType = 'okta'
        AND eventName = 'user.authentication.sso'
        AND receivedAt BETWEEN {to:DateTime} - INTERVAL 1 DAY AND {to:DateTime}
    GROUP BY
        email
    HAVING auth_count > 7
)
SELECT
    logs.actor['email'] AS email,
    auth_events.email,
    auth_events.auth_count,
    min(logs.eventTime),
    simpleJSONExtractRaw(JSONExtractArrayRaw(logs.rawLog,'target')[1], 'alternateId') app
FROM
    logs
JOIN
    auth_events ON auth_events.email = email
JOIN
    logged_events ON logged_events.email = email
WHERE
    logs.sourceType = 'okta'
    AND logs.eventName = 'user.authentication.sso'
    AND logs.receivedAt BETWEEN {to:DateTime} - INTERVAL 7 DAY AND {to:DateTime}
GROUP BY email, auth_events.email, auth_events.auth_count, app ORDER BY
    auth_count ASC, email;