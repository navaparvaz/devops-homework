#!/bin/bash



if [ -z "$1" ] || [ -z "$2" ]; then

    echo "Usage: $0 <file.tar.gz> <dest>"

    exit 1

fi



mkdir -p "$2"

tar -xzf "$1" -C "$2"

echo "Restored to $2"

ls -la "$2"
