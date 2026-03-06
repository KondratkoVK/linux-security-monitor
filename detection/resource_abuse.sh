#!/bin/bash

METRIC_FILE="/metrics/cpu_usage.prom"

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1)

echo "cpu_abuse_metric $CPU" > $METRIC_FILE
