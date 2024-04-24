WITH crypto AS
    (
        SELECT array_agg(ip) AS domains
        FROM threat_feed_ip_list
        WHERE feedName = 'Crypto_Domains'
    )
SELECT aws_dns_logs.*
FROM aws_dns_logs
CROSS JOIN crypto
WHERE arrayExists(x -> (queryName LIKE concat('%', x, '%')), crypto.domains) AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime}))
;

