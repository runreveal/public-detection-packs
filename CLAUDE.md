# Public Detection Development Guide

There are two types of detections in this repository.

- Detections that are ClickHouse queries.
- Detections that are Sigma rules.

Detection queries have two files, a yaml and a sql file. Sigma detections only have one yaml file and they are stored within a `sigma` folder.

The yaml file contains metadata about the detection such as
description, severity, and schedule.

**Important:** All new detections must include `disabled: true` at the top of the yaml file. This ensures detections are reviewed and explicitly enabled before going live.

Here's an example detection yaml for a ClickHouse query:

```yaml
disabled: true
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
mitreAttacks that we've added to the format.

```yaml
disabled: true
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
mitreAttacks:
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

## Display Name Convention

The `displayName` field is what users see in the UI when viewing detections in the queries and alerts lists. It should follow a consistent convention to make it immediately clear which service or platform the detection applies to.

### Display Name Format

**Format:** `{Service Name} {Description in Title Case}`

**Examples:**
- ✅ `Google Workspace Failed Login`
- ✅ `AWS S3 Bucket Created or Deleted`
- ✅ `Okta User Access from New Country`
- ✅ `Cloudflare File Downloaded`
- ❌ `failed-login` (missing service prefix)
- ❌ `Bucket Created or Deleted` (missing service prefix)
- ❌ `user-access-new-country` (kebab-case instead of Title Case)

### Service Name Prefixes

Use these standard prefixes for consistency:

- **AWS** - Amazon Web Services (e.g., `AWS Root Account Usage`)
- **Azure Entra** - Microsoft Entra ID (e.g., `Azure Entra New Global Admin User`)
- **Cloudflare** - Cloudflare services (e.g., `Cloudflare API Abuse`)
- **GCP** - Google Cloud Platform (e.g., `GCP Service Account Created`)
- **GitHub** - GitHub services (e.g., `GitHub Branch Protection Override`)
- **Google Workspace** - Google Workspace/GSuite (e.g., `Google Workspace Document Made Public`)
- **GSuite** - Legacy Google Workspace (e.g., `GSuite Many Downloads`)
- **Notion** - Notion workspace (e.g., `Notion Audit Log Exported`)
- **Okta** - Okta identity platform (e.g., `Okta Push Fatigue`)
- **Zendesk** - Zendesk services (e.g., `Zendesk Bulk User Deletion`)

### Guidelines

1. **Always include the service name** - Users should never have to guess which service a detection applies to
2. **Use Title Case** - Capitalize the first letter of each major word (avoid kebab-case or snake_case)
3. **Be descriptive but concise** - The name should clearly indicate what the detection does without being overly verbose
4. **Match the detection purpose** - The display name should align with what the detection actually monitors

### Sigma Detections

For Sigma detections, use the `title` field instead of `displayName`, following the same convention:

```yaml
title: Google Workspace Application Removed
```

### MITRE

Our detection schema supports MITRE Tactics and Techniques. Their key names are `mitreAttacks` and `mitreTechniques`. 
The values for these fields should be the IDs only, not text slugs.
