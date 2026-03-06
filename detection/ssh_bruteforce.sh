#!/bin/bash

LOG="/var/log/auth.log"
METRIC_FILE="/home/creator/linux-security-monitor/metrics/ssh_bruteforce.prom"

ATTEMPTS=$(grep "Failed password" $LOG | tail -n 100 | wc -l)

echo "# HELP ssh_failed_logins Number of failed SSH login attempts" > $METRIC_FILE
echo "# TYPE ssh_failed_logins gauge" >> $METRIC_FILE
echo "ssh_failed_logins $ATTEMPTS" >> $METRIC_FILE
