#!/bin/bash

LOG="/var/log/auth.log"
THRESHOLD=10

ATTEMPTS=$(grep "Failed password" $LOG | tail -n 100 | wc -l)

if [ "$ATTEMPTS" -gt "$THRESHOLD" ]; then
    echo "ALERT: Possible SSH brute force detected ($ATTEMPTS attempts)"
fi
