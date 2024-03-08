SELECT eventTime, srcIP, sourceType, eventName, actor FROM runreveal_logs INNER JOIN threat_feed_ip_list 
  ON runreveal_logs.srcIP = threat_feed_ip_list.ip
WHERE threat_feed_ip_list.feedName = 'Okta Unauthorized Access'
AND actor <> '{}'
AND receivedAt BETWEEN {from:DateTime} AND {to:DateTime}