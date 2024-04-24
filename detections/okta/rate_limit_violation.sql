SELECT *
FROM okta_logs
WHERE (eventType = 'system.operation.rate_limit.violation') AND ((receivedAt >= {from:DateTime}) AND (receivedAt <= {to:DateTime})) AND (NOT has({ignoreIPs:Array(String)}, srcIP)) AND (NOT has({ignoreEmails:Array(String)}, actor.alternateID))
ORDER BY eventTime ASC
;

