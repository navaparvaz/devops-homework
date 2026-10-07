#!/bin/bash



# ==========================================

# Section 3 - Service Status and Runlevels

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



log "1) Check status of ssh service"

systemctl status ssh --no-pager



log "2) Start ssh service"

systemctl start ssh



log "2) Stop ssh service"

systemctl stop ssh



log "2) Restart ssh service"

systemctl restart ssh

systemctl status ssh --no-pager



log "3) Enable ssh service to start automatically"

systemctl enable ssh



log "4) List all currently active services"

systemctl list-units --type=service --state=active --no-pager



log "5) Determine current runlevel (two methods)"

echo "--- Method 1: runlevel command ---"

runlevel

echo "--- Method 2: who -r ---"

who -r



log "6) Difference between init and systemd:"

echo "init    -> old system, sequential startup, uses /etc/inittab, SysV scripts"

echo "systemd -> modern system, parallel startup, uses unit files, targets instead of runlevels"



log "7) What was inittab and why is it no longer used?"

echo "/etc/inittab defined the default runlevel and per-runlevel scripts (SysV init)."

echo "systemd replaced it because it starts services in parallel, faster, and uses unit files."



log "8) systemd targets for runlevel 3 and runlevel 5"

echo "runlevel 3 -> multi-user.target"

echo "runlevel 5 -> graphical.target"



log "9) Default boot target"

systemctl get-default



log "===== END ====="



# ---------- SHOW OUTPUT ----------

echo ""

echo "======================================"

echo "  FINAL OUTPUT (from output.log)"

echo "======================================"

cat output.log
