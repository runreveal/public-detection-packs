select *  from okta_logs where eventType in
  ('user.session.impersonation.grant', 'user.session.impersonation.initiate')
  and receivedAt BETWEEN {from:DateTime} AND {to:DateTime}