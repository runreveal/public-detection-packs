SELECT max(eventTime) eventTime, max(receivedAt) receivedAt, actor, srcIP, srcASCountryCode, count(*) downloadCnt
  FROM logs 

  WHERE sourceType = 'gsuite'

  AND eventName = 'download' AND actor['email'] <> ''

  AND logs.receivedAt BETWEEN {from:DateTime} AND {to:DateTime}

  GROUP BY actor, srcIP, srcASCountryCode

  HAVING downloadCnt >= toInt64({threshold:String})

  ORDER BY downloadCnt DESC
