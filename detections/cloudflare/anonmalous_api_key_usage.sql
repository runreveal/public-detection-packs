WITH OLD AS (
        select 
        actorEmail oldactor,
        arrayDistinct(
            groupArray(srcASOrganization)
        ) asOrg 
        from 
        cf_audit_logs
        where 
        eventTime BETWEEN now() - INTERVAL 1 MONTH 
        AND now() - INTERVAL 30 MINUTE
        AND lower(interface) LIKE '%api%' 
        AND srcIP!=''
        group by 
        actorEmail
    ) 
SELECT 
    DISTINCT actor, 
    srcASOrganization, 
    if(
    isNull(oldactor) = 0, 
    'true', 
    'false'
    ) newActor
FROM 
    (
    SELECT 
        DISTINCT actorEmail actor, 
        srcASOrganization 
    from 
        cf_audit_logs
    where 
        eventTime >= now() - INTERVAL 30 MINUTE
        AND lower(interface) like '%api%'
        AND srcIP!=''
        AND srcASOrganization IS NOT NULL
    ) lastThirty
    LEFT OUTER JOIN OLD ON lastThirty.actor = OLD.oldactor
WHERE 
    has(asOrg, srcASOrganization) = 0;