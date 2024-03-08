SELECT acceptTime, acceptUser, inviteAt, invitedBy, 'INVITE LINK' inviteFrom
    FROM

    (SELECT eventTime acceptTime, `actor.loginName` acceptUser, `target.id`
    inviteID

    FROM tailscale_audit_logs

    WHERE eventName = 'ACCEPT_INVITE' AND acceptTime BETWEEN {from:DateTime} AND
    {to:DateTime}) accept INNER JOIN
        (SELECT eventTime inviteAt, `actor.loginName` invitedBy, `target.id` inviteID
        FROM tailscale_audit_logs
        WHERE eventName = 'CREATE_INVITE') create ON accept.inviteID = create.inviteID
    UNION ALL

    SELECT acceptTime, acceptUser, createTime, createUser, 'EMAIL INVITE'
    inviteFrom FROM

    (SELECT eventTime acceptTime, `actor.loginName` acceptUser, `target.name`
    inviteName

    FROM tailscale_audit_logs

    WHERE eventName = 'CREATE_USER' AND acceptTime BETWEEN {from:DateTime} AND
    {to:DateTime}) accept INNER JOIN
        (SELECT eventTime createTime, `actor.loginName` createUser, `target.name` inviteName
        FROM tailscale_audit_logs
        WHERE eventName = 'INVITE_USER') create ON accept.inviteName = create.inviteName