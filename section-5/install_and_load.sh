#!/bin/bash



LOG="/var/log/install_script.log"



if [ "$EUID" -ne 0 ]; then

    echo "Run with sudo"

    exit 1

fi



if [ -z "$1" ]; then

    echo "Usage: $0 <package>"

    exit 1

fi



echo "Installing $1..." | tee -a "$LOG"

apt install -y "$1" >>"$LOG" 2>&1



LOAD=$(cut -d' ' -f1 /proc/loadavg)

echo "Load: $LOAD" | tee -a "$LOG"



if (( $(echo "$LOAD > 2.0" | bc -l) )); then

    echo "WARNING: high load" | tee -a "$LOG"

fi
