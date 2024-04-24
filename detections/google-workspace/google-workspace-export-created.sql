SELECT *
FROM google_workspace_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND (eventName = 'CUSTOMER_TAKEOUT_CREATED')
LIMIT 1 BY
    eventName,
    `actor.email`
;

