WITH
    currentEvents AS
    (
        SELECT *
        FROM one_password_logs
        WHERE ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime})) AND (`client.appName` != '') AND (`client.platformName` != '') AND (`actor.email` NOT LIKE '%1passwordserviceaccounts.com')
    ),
    previousClients AS
    (
        SELECT
            `actor.email` AS user,
            groupUniqArray((`client.appName`, `client.platformName`)) AS clients
        FROM one_password_logs
        WHERE ((receivedAt >= ({from:DateTime} - toIntervalDay(30))) AND (receivedAt < {from:DateTime})) AND (`client.appName` != '') AND (`client.platformName` != '') AND (`actor.email` IN (SELECT `actor.email` FROM currentEvents))
        GROUP BY user
    )
SELECT
    currentEvents.*,
    previousClients.clients AS previousClients
FROM currentEvents
INNER JOIN previousClients ON previousClients.user = currentEvents.`actor.email`
WHERE NOT has(previousClients.clients, (currentEvents.`client.appName`, currentEvents.`client.platformName`))
