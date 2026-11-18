# Public Detection Packs

RunReveal's public detection packs: the SQL and Sigma detections behind the managed detections you can subscribe to in RunReveal. Each detection is a plain file you can read, copy, and change.

To manage your own detections as code, start with the [Detection as Code documentation](https://docs.runreveal.com/detections/detection-as-code). It covers installing the RunReveal CLI, the detection file format, testing and uploading, and deploying from CI.

## Using this repository

To subscribe to these detections without maintaining them yourself, use the Detection Library in the RunReveal app. See [Managed Detections](https://docs.runreveal.com/detections#managed-detections).

To extend them, clone the repository and use it as a starting point:

```sh
git clone https://github.com/runreveal/public-detection-packs.git
```

Then edit or add detections and deploy them to your workspace with the CLI or CI workflows described in the [Detection as Code documentation](https://docs.runreveal.com/detections/detection-as-code).

The detections also work as examples when you write new ones with a coding agent. Point the agent at an existing detection for the same log source and at [CLAUDE.md](CLAUDE.md), which describes the conventions this repository follows for metadata, categories, display names, and MITRE IDs.

## Layout

Detections live under `detections/`, grouped by log source (`aws`, `okta`, `github`, and so on). Some sources have subdirectories for individual log types, such as `detections/aws/cloudtrail` and `detections/aws/guardduty`.

There are two kinds of detection:

- SQL detections are scheduled ClickHouse queries. Each one is a YAML metadata file (name, schedule, severity, source types) plus the `.sql` file it references.
- Sigma detections are single YAML files in Sigma format with a few RunReveal-specific fields. Most live in a `sigma/` directory under their source. See [Sigma Streaming](https://docs.runreveal.com/detections/sigma-streaming).

A few directories hold detections that are not tied to one source:

- `general` queries logs from all sources, for example impossible travel and Tor exit node traffic.
- `alerts` builds alerts from existing detection results, such as initial access followed by another attack technique.
- `emerging-threats` matches known threat infrastructure: Tor nodes, malware IOCs, and DPRK C2 domains.
- `health-checks` alert when a source stops sending logs or its logs arrive late.

## Contributing

Pull requests run [detection-lint-action](https://github.com/runreveal/detection-lint-action) and a dry run of [detection-sync-action](https://github.com/runreveal/detection-sync-action). Follow the conventions in [CLAUDE.md](CLAUDE.md) and the guidance in [How to Write Detections](https://docs.runreveal.com/detections/writing-detections).
