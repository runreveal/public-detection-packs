select *  from cf_audit_logs where eventName in ('token_create',
  'rotate_API_key') and receivedAt BETWEEN {from:DateTime} AND {to:DateTime}