#!/bin/bash



exec > >(tee output.log) 2>&1



echo "===== START ====="



chmod +x install_and_load.sh backup.sh restore.sh



# Task 5.1

echo "--- Test 5.1 ---"

./install_and_load.sh curl



# Task 5.2

echo "--- Test 5.2 ---"

mkdir -p /tmp/testdata

echo "hello" > /tmp/testdata/a.txt



./backup.sh /tmp/testdata



echo "Backups:"

ls /backups/



LATEST=$(ls -t /backups/backup_*.tar.gz | head -1)



./restore.sh "$LATEST" /tmp/restored



echo "===== END ====="



cat output.log
