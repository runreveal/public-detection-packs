SELECT
*
FROM
  cf_gateway_http_logs
WHERE 
  receivedAt > {from:DateTime} and receivedAt <= {to:DateTime}
  AND not empty(DownloadedFileNames)
  AND NOT (length(DownloadedFileNames) = 1 AND DownloadedFileNames[1] = '<unknown file name>')
  AND Action='allow'
