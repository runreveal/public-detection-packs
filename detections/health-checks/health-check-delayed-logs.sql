SELECT 
    {sourceID:String} as sourceID,
    COALESCE(ROUND((quantile(0.50)(value)) / 3600000, 2), 0) as avgLatencyHours,
    COALESCE(ROUND(
        quantile(0.50)(
            IF(timestamp >= now() - INTERVAL 10 MINUTE, value, NULL)
        ) / 3600000, 2), 0) as lastEventLatencyHours
FROM external_metrics
WHERE 
    series = 'event_latency_ms'
    AND timestamp >= now() - INTERVAL {duration:UInt64} HOUR
    AND tags['sourceid'] = {sourceID:String}
GROUP BY sourceID