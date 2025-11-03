SELECT
    dstASCountryCode,
    dstIP,
    srcIP,
    aid,
    event_simpleName,
    COUNT(*) AS connection_count,
    groupArray(DISTINCT ImageFileName) AS process_names,
    MIN(receivedAt) AS first_connection,
    MAX(receivedAt) AS last_connection,
    MAX(receivedAt) AS receivedAt
FROM crowdstrike_data_logs
WHERE
    (receivedAt >= {from:DateTime})
    AND (receivedAt <= {to:DateTime})
    AND event_simpleName IN ('NetworkConnectIP4', 'NetworkConnectIP6')
    AND dstASCountryCode != ''
    AND has({embargoedCountries:Array(String)}, dstASCountryCode)
GROUP BY
    dstASCountryCode,
    dstIP,
    srcIP,
    aid,
    event_simpleName
ORDER BY connection_count DESC
