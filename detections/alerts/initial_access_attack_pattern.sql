WITH actor_and_ips AS
    (
        SELECT
            actor['email'] AS actorEmail,
            groupArrayDistinct(srcIP) AS srcIPs
        FROM detections
        WHERE (receivedAt > (now() - toIntervalSecond(({window:UInt64} * 2) + 60))) AND (NOT has({ignoreIPs:Array(String)}, srcIP)) AND (NOT has({ignoreEmails:Array(String)}, actor['email'])) AND (srcIP != '') AND ((actor['email']) != '')
        GROUP BY actor['email']
    )
SELECT *
FROM
(
    SELECT
        actor['email'] AS actor,
        arrayStringConcat(groupUniqArray(detectionName), ', ') AS signals,
        windowFunnel({window:UInt64})(eventTime, mitreAttack = 'initial-access', (mitreAttack IN ('discovery', 'execution', 'persistence', 'privilege-escalation', 'evasion', 'credential-access', 'lateral', 'collection')) AND (createdAt > {from:DateTime})) AS limit
    FROM
    (
        SELECT
            createdAt,
            eventTime,
            actor,
            detectionName,
            mitreAttacks AS mitreAttack
        FROM detections
        LEFT ARRAY JOIN detections.mitreAttacks
        INNER JOIN actor_and_ips ON (actor['email']) = actorEmail
        WHERE receivedAt > (now() - toIntervalSecond(({window:UInt64} * 2) + 60))
    )
    GROUP BY actor
    HAVING limit >= {signalCount:UInt64}
)
;

