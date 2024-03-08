WITH arns_and_events as (
    select
    DISTINCT `userIdentity.accessKeyId` accessKeyId,
    groupUniqArray(srcASNumber) srcASNumbers
    from cloudtrail_logs
    WHERE
    eventTime BETWEEN {from:DateTime} - toIntervalDay({window:UInt32}) AND {from:DateTime}
    AND accessKeyId like 'AKIA%'
    GROUP BY accessKeyId
)
SELECT
    `userIdentity.accessKeyId` accessKeyId,
    `userIdentity.userName`,
    srcIP,
    srcASNumber,
    srcASOrganization,
    groupUniqArrayArray(resources)
from cloudtrail_logs
LEFT OUTER JOIN arns_and_events ON arns_and_events.accessKeyId = accessKeyId
WHERE
    receivedAt BETWEEN {from:DateTime} AND {to:DateTime}
    AND eventName!=''
    AND NOT has({ignoreNetworksByAS:Array(UInt32)}, srcASNumber)
    AND accessKeyId LIKE 'AKIA%'
    AND NOT has(arns_and_events.srcASNumbers, srcASNumber)
    AND NOT has({ignoreIPs:Array(String)}, srcIP)
GROUP BY accessKeyId,`userIdentity.userName`, srcIP, srcASNumber, srcASOrganization