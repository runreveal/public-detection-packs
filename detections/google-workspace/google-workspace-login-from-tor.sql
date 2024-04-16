SELECT * from google_workspace_logs as g
LEFT OUTER JOIN threat_feed_ip_list as t on t.ip=g.srcIP
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
and g.eventName='login_success' and t.feedName='Tor Exit' LIMIT 1
