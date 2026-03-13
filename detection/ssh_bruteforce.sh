#!/bin/bash

LOG="/var/log/auth.log"

# путь к папке скрипта
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# папка metrics относительно проекта
METRICS_DIR="$SCRIPT_DIR/../metrics"
mkdir -p "$METRICS_DIR"

# файл метрик
METRIC_FILE="$METRICS_DIR/ssh_bruteforce.prom"

NOW=$(date +%s)
WINDOW=120

echo "# HELP ssh_failed_logins Failed SSH login attempts per IP in last 2 minutes" > "$METRIC_FILE"
echo "# TYPE ssh_failed_logins gauge" >> "$METRIC_FILE"

tail -n 500 "$LOG" | grep "Failed password" | while read line
do
    LOG_TIME=$(echo "$line" | awk '{print $1}')
    LOG_TIMESTAMP=$(date -d "$LOG_TIME" +%s 2>/dev/null)

    if [ -z "$LOG_TIMESTAMP" ]; then
        continue
    fi

    if [ $((NOW - LOG_TIMESTAMP)) -le $WINDOW ]; then
        IP=$(echo "$line" | grep -oP 'from \K[0-9.]+')
        echo "$IP"
    fi

done | sort | uniq -c | while read count ip
do
    echo "ssh_failed_logins{ip=\"$ip\"} $count" >> "$METRIC_FILE"
done
