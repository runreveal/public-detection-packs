SELECT *
  FROM okta_logs
  WHERE receivedAt between {from:DateTime} and {to:DateTime}
    AND eventName = 'user.session.start'
    AND outcome = 'SUCCESS'
    and srcIP like '%.%.%.%'
    AND client.device = 'Computer'
and srcIP not in (
  SELECT DISTINCT srcIP from crowdstrike_aidmaster_logs where eventTime > now() - INTERVAL 3 DAY
)
