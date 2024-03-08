SELECT *,
        srcCity || ', ' || srcASCountryCode location, prevCity || ', ' || prevCC prevLocation,
        round(geoDistance(srcLongitude, srcLatitude, prevLon, prevLat) / 1609, 2) distanceMi,
        round(age('second', prevTime, eventTime) / 3600,2) timeDiff_Hours, round(distanceMi / timeDiff_Hours, 0) mph
    FROM (
select *,
        geohashEncode(srcLongitude, srcLatitude, 5) geoHash,
        countIf(eventTime < {from:DateTime}) over (PARTITION BY (actor['email'], geoHash)) visitCount,
        lagInFrame(srcASOrganization) over (PARTITION BY actor['email'] order by eventTime) as prevSrcAsOrg,
        lagInFrame(srcIP) over (PARTITION BY actor['email'] order by eventTime) as prevSrcIP,
        lagInFrame(srcLatitude) over (PARTITION BY actor['email'] order by eventTime) as prevLat,
        lagInFrame(srcLongitude) over (PARTITION BY actor['email'] order by eventTime) as prevLon,
        lagInFrame(eventTime) over (PARTITION BY actor['email'] order by eventTime) as prevTime,
        lagInFrame(srcASCountryCode) over (PARTITION BY actor['email'] order by eventTime) as prevCC,
        lagInFrame(srcCity) over (PARTITION BY actor['email'] order by eventTime) as prevCity,
        lagInFrame(sourceType) over (PARTITION BY actor['email'] order by eventTime) as prevSourceType
        from
        (Select * from runreveal_logs
                    where
                    nullIf(srcLatitude, 0) IS NOT NULL AND nullIf(srcLongitude, 0) IS NOT NULL
                                        AND receivedAt >= {from:DateTime} - INTERVAL 24 HOUR AND sourceType != 'gsuite' AND sourceType!='flow'))
    WHERE srcLatitude <> prevLat AND srcLongitude <> prevLon AND timeDiff_Hours > 0 AND
            receivedAt BETWEEN {from:DateTime} AND {to:DateTime} AND prevSrcIP!=srcIP AND srcASOrganization!=prevSrcAsOrg AND
        mph > 767 AND distanceMi > 250 AND visitCount = 0
    order by mph desc, eventTime desc