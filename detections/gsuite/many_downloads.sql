WITH document_details AS (
    SELECT
        eventTime,
        receivedAt,
        actor,
        srcIP,
        srcASCountryCode,
        rawLog,
        JSONExtractString(
            arrayFirst(x -> JSONExtractString(x, 'name') = 'doc_id', 
                JSONExtractArrayRaw(JSONExtractArrayRaw(rawLog, 'events')[1], 'parameters')
            ), 'value'
        ) as doc_id,
        JSONExtractString(
            arrayFirst(x -> JSONExtractString(x, 'name') = 'doc_type', 
                JSONExtractArrayRaw(JSONExtractArrayRaw(rawLog, 'events')[1], 'parameters')
            ), 'value'
        ) as doc_type,
        JSONExtractString(
            arrayFirst(x -> JSONExtractString(x, 'name') = 'doc_title', 
                JSONExtractArrayRaw(JSONExtractArrayRaw(rawLog, 'events')[1], 'parameters')
            ), 'value'
        ) as doc_title
    FROM logs
    WHERE (sourceType = 'gsuite') AND (eventName = 'download') 
        AND ((actor['email']) != '') 
        AND ((logs.receivedAt >= {from:DateTime}) AND (logs.receivedAt <= {to:DateTime}))
)
SELECT
    max(eventTime) AS eventTime,
    max(receivedAt) AS receivedAt,
    actor,
    srcIP,
    srcASCountryCode,
    count(*) AS downloadCnt,
    groupArray(
        concat(
            coalesce(doc_title, 'Untitled'),
            ': ',
            CASE 
                WHEN doc_type = 'document' 
                    THEN concat('https://docs.google.com/document/d/', doc_id)
                WHEN doc_type = 'spreadsheet' 
                    THEN concat('https://docs.google.com/spreadsheets/d/', doc_id)
                WHEN doc_type = 'presentation' 
                    THEN concat('https://docs.google.com/presentation/d/', doc_id)
                ELSE concat('https://drive.google.com/file/d/', doc_id)
            END
        )
    ) AS downloaded_files
FROM document_details
GROUP BY
    actor,
    srcIP,
    srcASCountryCode
HAVING downloadCnt >= toInt64({threshold:String})
ORDER BY downloadCnt DESC
