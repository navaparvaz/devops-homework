#!/bin/bash



# ==========================================

# Section 1 - User and Group Management

# Run + Log + Show  (all in one)

# ==========================================



# Save all output to output.log

exec > >(tee output.log) 2>&1



# Simple log function

log() {

    echo "[$(date '+%H:%M:%S')] $1"

}



# Check for root

if [ "$EUID" -ne 0 ]; then

    log "ERROR: run with sudo"

    exit 1

fi



log "===== START ====="



log "1) Create group developers"

groupadd developers



log "2) Create user alice"

useradd -m -s /bin/bash alice



log "3) Set password for alice"

echo "alice:123456" | chpasswd



log "4) Create user bob without home"

useradd -M bob



log "5) Add alice to developers"

usermod -aG developers alice



log "6) Add bob to sudo"

usermod -aG sudo bob

groups bob



log "7) Rename developers to devteam"

groupmod -n devteam developers



log "8) Set alice account to expire on 2030-12-31"

chage -E 2030-12-31 alice

chage -l alice



log "9) Force alice to change password on next login"

chage -d 0 alice



log "10) Lock and unlock bob"

usermod -L bob

passwd -S bob

usermod -U bob

passwd -S bob



log "11) Delete bob"

userdel -r bob 2>/dev/null || userdel bob



log "12) Delete group devteam"

groupdel devteam



log "13) Difference between userdel and userdel -r:"

echo "userdel     -> removes user only"

echo "userdel -r  -> removes user + home + mail spool"



log "14) Configure sudoers for alice"

echo "alice ALL=(ALL) NOPASSWD: /bin/systemctl restart apache2" > /etc/sudoers.d/alice_apache

chmod 0440 /etc/sudoers.d/alice_apache

cat /etc/sudoers.d/alice_apache

echo "visudo is preferred because it checks syntax and locks the file."



log "===== END ====="



echo ""

echo "======================================"

echo "  FINAL OUTPUT (from output.log)"

echo "======================================"

cat output.log
