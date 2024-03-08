select * from cf_audit_logs where eventName in ('add_member',
  'accept_member', 'account_member_delete') and receivedAt BETWEEN {from:DateTime} AND {to:DateTime}