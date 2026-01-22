SELECT
    {sourceID:String} as sourceID,
    COALESCE(sum(value), 0) as eventCount,
    max(timestamp) as lastReceived
FROM external_metrics
WHERE timestamp >= now() - INTERVAL {duration:UInt64} HOUR
  AND series = 'events_by_source'
  AND tags['sourceid'] = {sourceID:String}