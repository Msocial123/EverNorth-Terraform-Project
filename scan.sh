#!/bin/bash

rm -rf reports
rm -rf logfile
mkdir -p reports
mkdir -p logfile

#timestamp=$(date +"%Y%m%d%H%M%S") //attaching timestamp if needed.

# Running the terrascan scan
/usr/local/bin/terrascan scan -t aws -d . -o json > reports/terrascan_report.json
/usr/local/bin/terrascan scan -t aws -d . -o text > reports/terrascan_report.txt

#Running the TFsec scan
/usr/local/bin/tfsec .  --format text > reports/tfsec_report.txt
/usr/local/bin/tfsec .  --format json > reports/tfsec_report.json

#Logging the critical and severe errors
grep -i -E 'critical|high|severe' reports/terrascan_report.txt > logfile/terrascan_issues.txt
grep -i -E 'critical|high|severe' reports/tfsec_report.txt > logfile/tfsec_issues.txt


echo "Terrascan and tfsec reports saved to $(pwd)/reports/"
echo "Critical issues are logged in $(pwd)/logfile/"
