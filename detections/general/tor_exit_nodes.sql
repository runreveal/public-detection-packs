SELECT
    eventTime,
    sourceType,
    eventName,
    srcIP,
    srcCity,
    srcASCountryCode,
    srcASOrganization,
    dstIP,
    dstCity,
    dstASCountryCode,
    dstASOrganization
FROM runreveal_logs
INNER JOIN threat_feed_ip_list ON (runreveal_logs.srcIP = threat_feed_ip_list.ip) OR (runreveal_logs.dstIP = threat_feed_ip_list.ip)
WHERE ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime})) AND (feedName = 'Tor Exit')
;

