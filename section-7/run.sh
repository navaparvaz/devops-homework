#!/bin/bash



# Section 7 - SSH Configuration



exec > >(tee output.log) 2>&1



if [ "$EUID" -ne 0 ]; then

    echo "Run with sudo"

    exit 1

fi



echo "===== START ====="



# Backup config

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak



# 1) Status

echo "--- 1) SSH status ---"

systemctl status ssh --no-pager | head -5



# 2) Edit sshd_config

echo "--- 2) Edit sshd_config ---"

sed -i 's/^#*Port .*/Port 2222/' /etc/ssh/sshd_config

sed -i 's/^#*PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config

sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config



grep -q "^AllowUsers" /etc/ssh/sshd_config && \

    sed -i 's/^AllowUsers.*/AllowUsers alice/' /etc/ssh/sshd_config || \

    echo "AllowUsers alice" >> /etc/ssh/sshd_config



grep -E "^(Port|PermitRootLogin|PasswordAuthentication|AllowUsers)" /etc/ssh/sshd_config



# 3) Restart

echo "--- 3) Restart SSH ---"

systemctl restart ssh

ss -tlnp | grep 2222



# 4) hosts.deny

echo "--- 4) Deny 192.168.1.50 ---"

grep -q "192.168.1.50" /etc/hosts.deny || echo "sshd: 192.168.1.50" >> /etc/hosts.deny

cat /etc/hosts.deny



# 5) hosts.allow

echo "--- 5) Allow 192.168.1.0/24 ---"

grep -q "192.168.1.0/24" /etc/hosts.allow || echo "sshd: 192.168.1.0/24" >> /etc/hosts.allow

cat /etc/hosts.allow



# 6) Generate key for alice

echo "--- 6) Generate key for alice ---"

mkdir -p /home/alice/.ssh

chown alice:alice /home/alice/.ssh

chmod 700 /home/alice/.ssh



sudo -u alice ssh-keygen -t rsa -N "" -f /home/alice/.ssh/id_rsa -q



cp /home/alice/.ssh/id_rsa.pub /home/alice/.ssh/authorized_keys

chown -R alice:alice /home/alice/.ssh

chmod 600 /home/alice/.ssh/authorized_keys



echo "--- .ssh contents ---"

ls -la /home/alice/.ssh/



echo "===== END ====="



cat output.log
