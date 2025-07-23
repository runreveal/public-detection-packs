SELECT *,
    -- Extract document information
    JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'doc_id', JSONExtractArrayRaw(event, 'parameters')), 'value') as doc_id,
    JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'doc_type', JSONExtractArrayRaw(event, 'parameters')), 'value') as doc_type,
    JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'doc_title', JSONExtractArrayRaw(event, 'parameters')), 'value') as doc_title,
    -- Assemble Google Docs URL
    CASE 
        WHEN JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'doc_type', JSONExtractArrayRaw(event, 'parameters')), 'value') = 'document' 
            THEN concat('https://docs.google.com/document/d/', JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'doc_id', JSONExtractArrayRaw(event, 'parameters')), 'value'))
        WHEN JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'doc_type', JSONExtractArrayRaw(event, 'parameters')), 'value') = 'spreadsheet' 
            THEN concat('https://docs.google.com/spreadsheets/d/', JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'doc_id', JSONExtractArrayRaw(event, 'parameters')), 'value'))
        WHEN JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'doc_type', JSONExtractArrayRaw(event, 'parameters')), 'value') = 'presentation' 
            THEN concat('https://docs.google.com/presentation/d/', JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'doc_id', JSONExtractArrayRaw(event, 'parameters')), 'value'))
        ELSE concat('https://drive.google.com/file/d/', JSONExtractString(arrayFirst(x -> JSONExtractString(x, 'name') = 'doc_id', JSONExtractArrayRaw(event, 'parameters')), 'value'))
    END as url
FROM google_workspace_logs
    ARRAY JOIN events as event
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime})
  AND (`id.applicationName` = 'drive')
  AND (JSONExtractString(event, 'type') = 'acl_change')
  AND (JSONExtractString(event, 'name') = 'change_document_visibility')
  AND arrayExists(param -> (JSONExtractString(param, 'name') = 'new_value' AND param LIKE '%people_with_link%'), JSONExtractArrayRaw(event, 'parameters'))
ORDER BY receivedAt DESC;
