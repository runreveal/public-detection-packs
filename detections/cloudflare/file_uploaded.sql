SELECT
*
FROM
  cf_gateway_http_logs
WHERE 
  receivedAt > {from:DateTime} and receivedAt <= {to:DateTime}
  AND not empty(UploadedFileNames)
  -- Original check for single unknown file
  AND NOT (length(UploadedFileNames) = 1 AND UploadedFileNames[1] = '<unknown file name>')
  -- New checks for length 2 arrays with specific combinations
  AND NOT (
    length(UploadedFileNames) = 2 AND (
      -- Check for ["blob", "<unknown file name>"] in any order
      (UploadedFileNames[1] = 'blob' AND UploadedFileNames[2] = '<unknown file name>') OR
      (UploadedFileNames[1] = '<unknown file name>' AND UploadedFileNames[2] = 'blob') OR
      -- Check for ["", "<unknown file name>"] in any order
      (UploadedFileNames[1] = '' AND UploadedFileNames[2] = '<unknown file name>') OR
      (UploadedFileNames[1] = '<unknown file name>' AND UploadedFileNames[2] = '')
    )
  )
  AND Action='allow'
