#!/bin/bash



if [ -z "$1" ]; then

    echo "Usage: $0 <dir>"

    exit 1

fi



mkdir -p /backups



STAMP=$(date '+%Y-%m-%d_%H-%M-%S')

FILE="/backups/backup_$STAMP.tar.gz"



tar -czf "$FILE" "$1"

echo "Saved: $FILE"



find /backups -name "backup_*.tar.gz" -mtime +7 -delete
