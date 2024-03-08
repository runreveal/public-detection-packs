select * from okta_logs where eventType IN ('system.api_token.create') and
  receivedAt BETWEEN {from:DateTime} AND {to:DateTime}