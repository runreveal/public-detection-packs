WITH crypto AS (SELECT array_agg(ip) as domains from threat_feed_ip_list
  WHERE feedName = 'Crypto_Domains')

select aws_dns_logs.* from aws_dns_logs
        CROSS JOIN crypto
WHERE arrayExists(x -> queryName LIKE '%' || x || '%', crypto.domains)

AND receivedAt BETWEEN {from:DateTime} AND {to:DateTime}