SELECT
*
FROM
  cf_gateway_http_logs
WHERE 
  receivedAt > {from:DateTime} and receivedAt <= {to:DateTime}
  AND not empty(UploadedFileNames)
  AND NOT (length(UploadedFileNames) = 1 AND UploadedFileNames[1] = '<unknown file name>')
  AND Action='allow'
