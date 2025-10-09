# Public Detection Development Guide

There are two types of detections in this repository.

- Detections that are ClickHouse queries.
- Detections that are Sigma rules.

Detection queries have two files, a yaml and a sql file. Sigma detections only have one yaml file and they are stored within a `sigma` folder.

The yaml file contains metadata about the detection such as
description, severity, and schedule.

Here's an example detection yaml for a ClickHouse query:

```yaml
name: google-workspace-access-transparency-resource
displayName: Access Transparency GSuite Resource Events
description: Detects Google Workspace events where the application is not access_transparency and the event type is GSUITE_RESOURCE.
file: google-workspace-access-transparency-gsuite-resource.sql
categories:
  - runreveal-detection
  - signal
  - google-workspace
  - gsuite
  - access-transparency
mitreAttacks:
  - discovery
severity: Medium
riskScore: 50
schedule: "*/15 * * * *"
parameters:
  window: "30"
sourceTypes:
  - google-workspace
  - gsuite
```

When you write a ClickHouse query you should always.

- Frame the time using WHERE (receivedAt > {from:DateTime})
  AND (receivedAt < {to:DateTime}).
- Select as many fields as possible (SELECT \*).

Sigma detections are the standard sigma format, however we've
added a few extra fields that we support that are not in the
original sigma format. Here's an example containing riskscore
mitreattacks that we've added to the format.

```yaml
title: Google Workspace Application Removed
id: ee2803f0-71c8-4831-b48b-a1fc57601ee4
description: Detects when an an application is removed from Google Workspace.
references:
  - https://cloud.google.com/logging/docs/audit/gsuite-audit-logging#3
  - https://developers.google.com/admin-sdk/reports/v1/appendix/activity/admin-domain-settings?hl=en#REMOVE_APPLICATION
  - https://developers.google.com/admin-sdk/reports/v1/appendix/activity/admin-domain-settings?hl=en#REMOVE_APPLICATION_FROM_WHITELIST
author: Austin Songer
date: 2021-08-26
modified: 2023-10-11
tags:
  - attack.impact
sourcetypes:
  - gsuite
detection:
  selection:
    eventService: admin.googleapis.com
    eventName:
      - REMOVE_APPLICATION
      - REMOVE_APPLICATION_FROM_WHITELIST
  condition: selection
falsepositives:
  - Application being removed may be performed by a System Administrator.
level: medium
riskscore: 50
mitreattacks:
  - impact
```

## Categories/Tags

SQL detections should use the property `categories` when adding additional information. Sigma detections should use the property `tags` when adding the same information.

When adding categories to the rules, make sure they follow this convention:

Category Structure
Categories must follow this hierarchical order:

1. Service Name (Required)
1. Security Category (Required)
1. Signal Classification (Required)
1. Additional Tags (Optional)

### Category Definitions

**1. Service Name**
The primary service or platform generating the alert.
Examples:

- `cloudflare`, `cf-audit`
- `aws`, `s3`, `ec2`, `dns`
- `azure`, `gcp`

**2. Security Category**
Security domain classification based on OCSF (Open Cybersecurity Schema Framework) schema - https://schema.ocsf.io/

Standard Categories (OCSF Framework):

- system-activity - System and endpoint events (file system, processes, kernel activities)
- findings - Security findings and detections (vulnerabilities, compliance, incidents)
- identity-access-management - Authentication, authorization, and user management events
- network-activity - Network connections, traffic, and communication events
- discovery - Asset inventory and configuration discovery activities
- application-activity - Application-specific events and behaviors
- audit-activity - Administrative and compliance-related events
- unmanned-systems - Drone and aviation security data (OCSF 1.4.0+)

**3. Signal Classification**
Distinguishes between different alert types. Detections without notificationNames are considered signals by default.

- signal - Actionable detection requiring investigation
- non-signal - The default and when signal is absent from the list of categories.

**4. Additional Tags**
Supplementary metadata for enhanced categorization.

Examples:
Attack techniques: persistence, privilege-escalation, lateral-movement
Asset types: production, staging, development
