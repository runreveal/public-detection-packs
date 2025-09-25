SELECT
    actorName,
    COUNT(*) as org_count,
    MIN(receivedAt) as first_creation,
    MAX(receivedAt) as last_creation,
    arrayStringConcat(groupArray(changeDescription), ', ') as organizations
FROM zendesk_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime})
  AND eventName = 'create'
  AND zendeskSourceType = 'organization'
  AND changeDescription LIKE '%Organization % created%'
GROUP BY actorName
HAVING org_count >= 5
ORDER BY org_count DESC
