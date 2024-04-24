SELECT *
FROM google_workspace_logs AS g
LEFT JOIN threat_feed_ip_list AS t ON t.ip = g.srcIP
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND (g.eventName = 'login_success') AND (t.feedName = 'Tor Exit')
LIMIT 1
;

