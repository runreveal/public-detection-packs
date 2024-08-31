WITH
    lower(actor['email']) AS email,
    simpleJSONExtractString(simpleJSONExtractRaw(simpleJSONExtractRaw(rawLog, 'debugContext'), 'debugData'), 'factor') AS factor,
    simpleJSONExtractString(simpleJSONExtractRaw(rawLog, 'outcome'), 'result') AS result
SELECT
    email,
    toStartOfTenMinutes(eventTime) AS interval,
    windowFunnel(600, 'strict_increase')(eventTime,
        result='FAILURE' AND factor='OKTA_VERIFY_PUSH',
        result='FAILURE' AND factor='OKTA_VERIFY_PUSH',
        result='FAILURE' AND factor='OKTA_VERIFY_PUSH',
        result='SUCCESS' AND factor='OKTA_VERIFY_PUSH'
    ) AS level
FROM (
    SELECT * FROM runreveal.logs WHERE sourceType='okta' AND
        -- Double the window size to catch overlaps
        receivedAt >= {from:DateTime} - INTERVAL dateDiff('s', {from:DateTime}, {to:DateTime}) SECOND AND
        receivedAt < {to:DateTime} AND
        factor = 'OKTA_VERIFY_PUSH'
) GROUP BY ALL
HAVING level >= 3