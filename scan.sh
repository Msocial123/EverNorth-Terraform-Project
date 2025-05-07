#!/bin/bash

mkdir -p reports

timestamp=$(date +"%Y%m%d%H%M%S")
# Running the terrascan scan
/usr/local/bin/terrascan scan -t aws -d . -o json > reports/terrascan_report_$timestamp.json

#Running the TFsec scan
/usr/local/bin/tfsec . --no-cache --format plain > reports/tfsec_report_$timestamp.txt

echo "Terrascan and tfsec reports saved to $(pwd)/reports/"

