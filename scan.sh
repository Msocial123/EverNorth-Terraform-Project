#!/bin/bash

mkdir -p reports

# Running the terrascan scan
/usr/local/bin/terrascan scan -t aws -d . -o text > reports/terrascan_report.txt

#Running the TFsec scan
/usr/local/bin/tfsec . --format plain > reports/tfsec_report.txt

echo "Terrascan and tfsec reports saved to $(pwd)/reports/"

