SELECT
  CASE
    WHEN actor['email'] != '' AND isNotNull(actor['email']) THEN actor['email']
    WHEN actor['username'] != '' AND isNotNull(actor['username']) THEN actor['username']
    WHEN actor['id'] != '' AND isNotNull(actor['id']) THEN actor['id']
    ELSE 'unknown'
  END as primary_actor_identifier,
  actor['email'] as actor_email,
  actor['username'] as actor_username,
  actor['id'] as actor_id,
  arrayStringConcat(groupUniqArray(detectionName), ', ') as detection_names,
  sum(riskScore) as total_risk_score,
  groupArray(map(
        'detectionName', detectionName,
        'results', JSONExtractRaw(results),
        'riskScore', toString(riskScore),
        'severity', severity,
        'mitreAttacks', arrayStringConcat(mitreAttacks, ', '),
        'eventTime', toString(eventTime),
        'createdAt', toString(createdAt)
  )) as signal_details,
  count() as signal_count
FROM (
  SELECT DISTINCT
    createdAt,
    eventTime,
    actor,
    detectionName,
    riskScore,
    severity,
    mitreAttacks,
    results
  FROM signals
  WHERE eventTime BETWEEN {from:DateTime} - toIntervalSecond(({window:UInt64}) + 60) AND {to:DateTime}
    AND riskScore > 0
    AND (
      (actor['email'] != '' AND isNotNull(actor['email'])) OR
      (actor['username'] != '' AND isNotNull(actor['username'])) OR
      (actor['id'] != '' AND isNotNull(actor['id']))
    )
)
GROUP BY
  primary_actor_identifier,
  actor['email'],
  actor['username'],
  actor['id']
HAVING
  max(receivedAt) > {from:DateTime} AND totalRiskScore > {risk_threshold:UInt32}
ORDER BY total_risk_score DESC
