SELECT *
FROM one_password_logs
WHERE
    (
        srcConnectionType IN ('vpn', 'proxy', 'hosting')
        OR srcISP LIKE '%VPN%'
        OR srcISP LIKE '%Proxy%'
        OR srcISP LIKE '%Cloud%'
        OR srcISP LIKE '%Hosting%'
        OR srcISP LIKE '%Virtual%'
    )
    AND (receivedAt >= {from:DateTime})
    AND (receivedAt <= {to:DateTime})
;
