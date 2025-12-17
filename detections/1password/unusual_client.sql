WITH previousClients AS
    (
        SELECT DISTINCT
            `actor.email` AS user,
            groupUniqArray((`client.appName`, `client.platformName`)) AS clients
        FROM one_password_logs
        WHERE ((receivedAt >= ({from:DateTime} - toIntervalDay(30))) AND (receivedAt <= {from:DateTime})) AND (NOT (`client.appName` IS NULL)) AND (`client.appName` != '') AND (`client.platformName` != '') AND (user NOT LIKE '%1passwordserviceaccounts.com')
        GROUP BY user
    )
SELECT
    one_password_logs.*,
    previousClients.clients AS previousClients
FROM one_password_logs
LEFT JOIN previousClients ON previousClients.user = `actor.email`
WHERE (NOT (`client.appName` IS NULL)) AND (`client.appName` != '') AND (`client.platformName` != '') AND (`actor.email` NOT LIKE '%1passwordserviceaccounts.com') AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime})) AND (previousClients.user != '') AND (NOT has(previousClients.clients, (`client.appName`, `client.platformName`)))
