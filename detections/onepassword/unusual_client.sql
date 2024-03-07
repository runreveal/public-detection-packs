select * from one_password_logs
where not isNull(`client.appName`) AND
      `client.appName` NOT IN {clients:Array(String)}
AND receivedAt BETWEEN {from:DateTime} AND {to:DateTime}