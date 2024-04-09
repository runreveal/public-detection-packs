#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 SOURCE NAME"
    exit 1
fi

SOURCE="$1"
NAME="$2"
# Slugify the combination of SOURCE and NAME
slug=$(echo "${SOURCE}-${NAME}" | tr '[:upper:]' '[:lower:]' | tr -s ' ' '-' | tr -cd 'a-z0-9-')

# Define the YAML template with placeholders for SOURCE, NAME, and SLUG
read -r -d '' ymltemplate <<EOF
# Remove disabled property to start using the detection
disabled: true

name: ${slug}
displayName: ${NAME}
description: Enter a description here.
file: ${slug}.sql
categories:
  - signal
  - ${SOURCE}
mitreAttacks:
  - execution
severity: Medium
schedule: '*/15 * * * *'
parameters:
  window: '30'
sourceTypes:
  - ${SOURCE}
EOF

read -r -d '' sqltemplate <<EOF
SELECT * from ${SOURCE}_logs
where receivedAt > {from:DateTime} and receivedAt < {to:DateTime}
EOF

# Create directory structure
mkdir -p "detections/${SOURCE}"

# Create the YAML file
echo "${ymltemplate}" > "detections/${SOURCE}/${slug}.yml"

# Create an empty SQL file
echo "${sqltemplate}" > "detections/${SOURCE}/${slug}.sql"

echo "Generated detection YAML and SQL files for ${SOURCE}-${NAME} at detections/${SOURCE}/${slug}.yml"

