SELECT actor['email'] actor, srcIP, srcASCountryCode, count(*) downloadCnt
  FROM runreveal_logs 

  WHERE sourceType = 'gsuite'

  AND eventName = 'download' AND actor <> ''

  AND receivedAt BETWEEN {from:DateTime} AND {to:DateTime}

  GROUP BY actor, srcIP, srcASCountryCode

  HAVING downloadCnt >= toInt64({threshold:String})

  ORDER BY downloadCnt DESC