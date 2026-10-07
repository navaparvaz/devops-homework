#!/bin/bash



exec > >(tee output.log) 2>&1



echo "===== START ====="



if [ "$EUID" -ne 0 ]; then

    echo "Run with sudo"

    exit 1

fi



echo "--- Running SQL ---"

mysql < setup.sql



echo "===== END ====="



cat output.log

echo "--- Cleanup ---"

mysql < cleanup.sql
