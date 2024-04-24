SELECT *
FROM gcp_logs
WHERE (receivedAt > {from:DateTime}) AND (receivedAt < {to:DateTime}) AND (methodName IN ('google.iam.admin.v1.WorkforcePools.CreateWorkforcePool', 'google.iam.admin.v1.WorkforcePools.DeleteWorkforcePool', 'google.iam.admin.v1.WorkforcePools.UpdateWorkforcePool'))
;

