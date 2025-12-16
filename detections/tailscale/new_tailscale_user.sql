SELECT
    acceptTime,
    acceptUser,
    inviteAt,
    invitedBy,
    'INVITE LINK' AS inviteFrom
FROM
(
    SELECT
        receivedAt AS acceptTime,
        `actor.loginName` AS acceptUser,
        `target.id` AS inviteID
    FROM tailscale_audit_logs
    WHERE (eventName = 'ACCEPT_INVITE') AND ((acceptTime >= {from:DateTime}) AND (acceptTime <= {to:DateTime}))
) AS accept
INNER JOIN
(
    SELECT
        receivedAt AS inviteAt,
        `actor.loginName` AS invitedBy,
        `target.id` AS inviteID
    FROM tailscale_audit_logs
    WHERE eventName = 'CREATE_INVITE'
) AS create ON accept.inviteID = create.inviteID
UNION ALL
SELECT
    acceptTime,
    acceptUser,
    createTime,
    createUser,
    'EMAIL INVITE' AS inviteFrom
FROM
(
    SELECT
        receivedAt AS acceptTime,
        `actor.loginName` AS acceptUser,
        `target.name` AS inviteName
    FROM tailscale_audit_logs
    WHERE (eventName = 'CREATE_USER') AND ((acceptTime >= {from:DateTime}) AND (acceptTime <= {to:DateTime}))
) AS accept
INNER JOIN
(
    SELECT
        receivedAt AS createTime,
        `actor.loginName` AS createUser,
        `target.name` AS inviteName
    FROM tailscale_audit_logs
    WHERE eventName = 'INVITE_USER'
) AS create ON accept.inviteName = create.inviteName
;

