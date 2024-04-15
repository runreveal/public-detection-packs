SELECT * from gcp_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
and methodName in ('google.iam.admin.v1.WorkforcePools.CreateWorkforcePool',
'google.iam.admin.v1.WorkforcePools.DeleteWorkforcePool',
'google.iam.admin.v1.WorkforcePools.UpdateWorkforcePool')
