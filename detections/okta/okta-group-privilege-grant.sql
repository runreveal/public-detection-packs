SELECT
  arrayFirst(x -> 1, target) as target_group_id,
  JSONExtractString(arrayFirst(x -> 1, target), 'displayName') as target_group_name,
  JSONExtractString(arrayFirst(x -> 1, target), 'alternateId') as target_group_alternate_id,
  JSONExtractString(rawLog, 'debugContext', 'debugData', 'privilegeGranted') as privilege_granted,
  *
FROM
  okta_logs
WHERE
  eventName = 'group.privilege.grant'
  AND receivedAt >= {from:DateTime}
  AND receivedAt < {to:DateTime}
