SELECT
    eventTime,
    srcIP,
    sourceType,
    eventName,
    actor
FROM runreveal_logs
INNER JOIN threat_feed_ip_list ON okta_logs.srcIP = threat_feed_ip_list.ip
WHERE (threat_feed_ip_list.feedName = 'Okta Unauthorized Access') AND (actor != '{}') AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
;

