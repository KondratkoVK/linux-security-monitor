#!/bin/bash

METRIC_FILE="/metrics/network_connections.prom"

CONNECTIONS=$(ss -tun | wc -l)

echo "network_connections $CONNECTIONS" > $METRIC_FILE
