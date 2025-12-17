WITH OLD AS
    (
        SELECT
            actorEmail AS oldactor,
            arrayDistinct(groupArray(srcASOrganization)) AS asOrg
        FROM cf_audit_logs
        WHERE ((receivedAt >= (now() - toIntervalMonth(1))) AND (receivedAt <= (now() - toIntervalMinute(30)))) AND (lower(interface) LIKE '%api%') AND (srcIP != '')
        GROUP BY actorEmail
    )
SELECT DISTINCT
    actor,
    srcASOrganization,
    if((oldactor IS NULL) = 0, 'true', 'false') AS newActor
FROM
(
    SELECT DISTINCT
        actorEmail AS actor,
        srcASOrganization
    FROM cf_audit_logs
    WHERE (receivedAt >= (now() - toIntervalMinute(30))) AND (lower(interface) LIKE '%api%') AND (srcIP != '') AND (srcASOrganization IS NOT NULL)
) AS lastThirty
LEFT JOIN OLD ON lastThirty.actor = OLD.oldactor
WHERE has(asOrg, srcASOrganization) = 0
;

