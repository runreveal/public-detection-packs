WITH previousClients as (select DISTINCT `actor.email` user,
groupUniqArray(client.appName) clients from one_password_logs
WHERE eventTime BETWEEN {from:DateTime} - INTERVAL 30 DAY AND {from:DateTime} AND not isNull(`client.appName`)
GROUP BY user)

select one_password_logs.*, previousClients.clients previousClients from one_password_logs
LEFT OUTER JOIN previousClients ON previousClients.user = `actor.email`
where not isNull(`client.appName`)
AND receivedAt BETWEEN {from:DateTime} AND {to:DateTime}
AND previousClients.user <> '' AND NOT has(previousClients.clients, one_password_logs.`client.appName`)