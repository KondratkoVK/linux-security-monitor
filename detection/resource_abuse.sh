#!/bin/bash

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1)

if [ "$CPU" -gt 80 ]; then
    echo "ALERT: High CPU usage detected: $CPU%"
fi
