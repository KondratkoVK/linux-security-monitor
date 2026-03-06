#!/bin/bash

CONNECTIONS=$(ss -tun | wc -l)

if [ "$CONNECTIONS" -gt 200 ]; then
    echo "ALERT: Possible network scan detected ($CONNECTIONS connections)"
fi
