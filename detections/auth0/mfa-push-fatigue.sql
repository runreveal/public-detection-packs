SELECT
    user_email,
    user_id,
    srcIP,
    count(*) AS pushNotificationCount,
    min(receivedAt) AS firstPush,
    max(receivedAt) AS lastPush,
    groupArray(type) AS eventTypes
FROM auth0_logs
WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime})
  AND (type IN ('pn', 'gd_send_pn'))
GROUP BY
    user_email,
    user_id,
    srcIP
HAVING pushNotificationCount >= {threshold:UInt32}
ORDER BY pushNotificationCount DESC;
