SELECT
    * EXCEPT rawLog,
    JSONExtractArrayRaw(rawLog, 'target') tgt
FROM runreveal.logs
WHERE (sourceType = 'okta') AND (
  eventName IN (
    'group.privilege.grant',
    'user.account.privilege.grant',
  )
) AND (receivedAt < {to:DateTime}) AND (receivedAt >= {from:DateTime})