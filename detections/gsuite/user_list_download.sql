select eventTime, actor['email'] user, srcIP, srcASOrganization, srcISP,
  srcCity, srcASCountryCode, srcLatitude, srcLongitude, srcISP

  from runreveal_logs where sourceType = 'gsuite'

  AND eventName LIKE 'DOWNLOAD_USERLIST%'

  AND receivedAt BETWEEN {from:DateTime} AND {to:DateTime}

  order by eventTime desc;