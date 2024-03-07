select * from okta_logs where
eventType='system.operation.rate_limit.violation'
        and receivedAt BETWEEN {from:DateTime} AND {to:DateTime}
AND NOT has({ignoreIPs:Array(String)}, srcIP) AND NOT has({ignoreEmails:Array(String)}, actor.alternateID) ORDER BY eventTime