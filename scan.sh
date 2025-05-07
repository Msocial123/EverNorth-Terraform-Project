#!/bin/bash

mkdir -p reports

# Running the terrascan scan
/usr/local/bin/terrascan scan -t aws -d . -o json > reports/terrascan_report.json

#Running the TFsec scan
/usr/local/bin/tfsec . --format json > reports/tfsec_report.json

echo "Terrascan and tfsec reports saved to $(pwd)/reports/"

