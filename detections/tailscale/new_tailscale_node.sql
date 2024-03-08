select eventTime, actor['email'] actor, JSONExtractString(rawLog, 'target',
  'name') nodeName, 
    JSONExtractBool(rawLog, 'target', 'isEphemeral') ephemeral
    from runreveal_logs where sourceType = 'tailscale-audit'
  AND eventName = 'CREATE_NODE' 

  AND (JSONExtractBool(rawLog, 'target', 'isEphemeral') = false OR 
    JSONExtractBool(rawLog, 'target', 'isEphemeral') = {includeEphemeral:Boolean})
  AND receivedAt BETWEEN {from:DateTime} AND {to:DateTime}