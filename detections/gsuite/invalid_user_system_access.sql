WITH invalidUsers AS (SELECT * FROM

  (SELECT delete.*, row_number() OVER (PARTITION BY delete.userEmail ORDER BY
  delete.eventTime DESC) rnum

  FROM (select eventTime, if(eventName = 'DELETE_USER', 'DELETED',
  'SUSPENDED') eventType, workspaceID,
        JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'USER_EMAIL',
                    JSONExtractArrayRaw(arrayFirst(x -> JSONExtractString(x, 'type') = 'USER_SETTINGS',
                                                  JSONExtractArrayRaw(rawLog, 'events')), 'parameters')), 'value') userEmail
        from runreveal_logs where sourceType = 'gsuite' and eventName IN ('DELETE_USER', 'SUSPEND_USER') AND eventTime BETWEEN {from:DateTime} - INTERVAL 90 DAY AND {to:DateTime}) delete
  LEFT OUTER JOIN (select eventTime, if(eventName = 'CREATE_USER', 'D', 'S')
  eventType, workspaceID,
        JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'USER_EMAIL',
                    JSONExtractArrayRaw(arrayFirst(x -> JSONExtractString(x, 'type') = 'USER_SETTINGS',
                                                  JSONExtractArrayRaw(rawLog, 'events')), 'parameters')), 'value') userEmail
        from runreveal_logs where sourceType = 'gsuite' and eventName IN ('CREATE_USER', 'UNSUSPEND_USER') AND eventTime BETWEEN {from:DateTime} - INTERVAL 90 DAY AND {to:DateTime}) create
          ON delete.userEmail = create.userEmail AND (delete.eventType = create.eventType) AND delete.workspaceID = create.workspaceID
  WHERE create.userEmail IS NULL OR create.userEmail = '' OR create.eventTime
  < delete.eventTime) where rnum = 1)

  SELECT
      invalidUsers.eventType invalidatedType, invalidUsers.eventTime invalidatedTime, invalidUsers.userEmail,
      runreveal_logs.id, runreveal_logs.eventTime, runreveal_logs.sourceType, runreveal_logs.sourceID, runreveal_logs.eventName,
      runreveal_logs.srcIP, runreveal_logs.srcASOrganization, runreveal_logs.srcCity, runreveal_logs.srcASCountryCode,
      runreveal_logs.srcLatitude, runreveal_logs.srcLongitude, runreveal_logs.rawLog
      from
      (SELECT * from runreveal_logs WHERE receivedAt BETWEEN {from:DateTime} AND {to:DateTime} AND actor['email'] <> '') runreveal_logs
          INNER JOIN invalidUsers ON runreveal_logs.actor['email'] = invalidUsers.userEmail AND runreveal_logs.workspaceID = invalidUsers.workspaceID
      where runreveal_logs.eventTime > invalidUsers.eventTime