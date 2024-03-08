select eventTime, eventID, srcIP, srcASOrganization, srcASCountryCode,
  srcLatitude, srcLongitude, initiatedBy, assignedUser, role

  FROM (select eventTime, eventID, srcIP, srcASOrganization, srcASCountryCode,
  srcLatitude, srcLongitude,
    actor['email'] initiatedBy,
    arrayFirst(x -> ((x.1) = 'User'),JSONExtract(JSON_QUERY(rawLog, '$.properties.targetResources[*]'), 'Array(Tuple(type String, userPrincipalName String, modifiedProperties Array(Tuple(displayName String, newValue String))))'))
      userVals, userVals.2 assignedUser,
      trim(BOTH '"' FROM arrayFirst(x -> ((x.1) = 'Role.DisplayName'), userVals.3).2) role
    ,rawLog
      from runreveal_logs WHERE
    eventName = 'Add member to role' AND
    sourceType = 'aad' AND
    JSONExtractString(rawLog, 'properties', 'operationType') = 'Assign' AND
    JSONExtractString(rawLog, 'properties', 'result') = 'success'
      AND role IN {roles:Array(String)}
      AND receivedAt BETWEEN {from:DateTime} AND {to:DateTime})