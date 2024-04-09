SELECT * from notion_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
and eventName='workspace.settings.publc_homepage_added'
