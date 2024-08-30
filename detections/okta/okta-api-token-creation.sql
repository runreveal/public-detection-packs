SELECT
  *
FROM
  runreveal.logs
WHERE
  sourceType = 'okta'
  AND eventName = 'system.api_token.create'
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime}