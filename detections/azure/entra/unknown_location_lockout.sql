select
      fails.*
      FROM (SELECT DISTINCT eventTime, actor['email'] user, srcIP,
          JSONExtractInt(rawLog, 'resultType') resultID,
          JSONExtractString(rawLog, 'resultDescription') resultDesc
          , rawLog from runreveal_logs
  where tags['category'] = 'SignInLogs' and eventName ='Sign-in activity' and
  sourceType = 'aad' and JSONExtractInt(rawLog, 'resultType') != 0
            AND eventTime BETWEEN {from:DateTime} AND {to:DateTime}) fails
  LEFT OUTER JOIN (select actor['email'] user, groupUniqArray(srcIP) ips from
  runreveal_logs
            where tags['category'] = 'SignInLogs' and eventName ='Sign-in activity' and sourceType = 'aad' and JSONExtractInt(rawLog, 'resultType') = 0
            AND eventTime BETWEEN {from:DateTime} - INTERVAL 30 DAY AND {from:DateTime}
  group by user) success ON fails.user = success.user WHERE NOT has(ips,
  srcIP) and length(ips) > 0 AND JSONExtractInt(rawLog, 'resultType') IN
  (50053);