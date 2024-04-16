SELECT * from gcp_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
AND methodName = 'SetIamPolicy' 
AND arrayExists(
    x -> JSONExtractString(x, 'member') LIKE '%@gmail.com',
    JSONExtractArrayRaw(rawLog, 'message', 'data', 'protoPayload', 'serviceData', 'policyDelta', 'bindingDeltas')
)
