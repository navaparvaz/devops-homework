#!/bin/bash



# ==========================================

# Section 4 - Networking

# Run + Log + Show  (all in one)

# ==========================================



exec > >(tee output.log) 2>&1



log() {

    echo "[$(date '+%H:%M:%S')] $1"

}



if [ "$EUID" -ne 0 ]; then

    log "ERROR: run with sudo"

    exit 1

fi



log "===== START ====="



# ---- auto-detect interface and gateway ----

IFACE=$(ip route | grep default | awk '{print $5}' | head -1)

GATEWAY=$(ip route | grep default | awk '{print $3}' | head -1)



log "Detected interface: $IFACE"

log "Detected gateway: $GATEWAY"



# ---- 1) Show IPs ----

log "1) Show IP addresses (ip a and ifconfig)"

echo "--- ip a ---"

ip a

echo "--- ifconfig ---"

ifconfig 2>/dev/null || echo "ifconfig not installed (needs net-tools)"

echo "Note: ifconfig needs the 'net-tools' package."



# ---- 2) Ping ----

log "2) Ping 8.8.8.8 with exactly 5 packets"

ping -c 5 8.8.8.8



# ---- 3) Telnet ----

log "3) Telnet test to google.com on port 80"

echo "A successful connection shows 'Connected to google.com'"

timeout 5 bash -c "echo -e 'GET / HTTP/1.0\r\n\r\n' | telnet google.com 80" || true



# ---- 4) netstat ----

log "4) Listening TCP ports with netstat"

netstat -tlnp 2>/dev/null || ss -tlnp



# ---- 5) lsof ----

log "5) Which process listens on port 22 (lsof)"

lsof -i :22 2>/dev/null || echo "lsof not installed or no process on port 22"



# ---- 6) nmap ----

log "6) nmap scan first 100 ports of localhost"

nmap -p 1-100 localhost



# ---- 7) route -n ----

log "7) Routing table with route -n"

route -n



# ---- 8) Add temporary route (uses real gateway) ----

log "8) Add temporary route to 192.168.100.0/24 via $GATEWAY"

if [ -n "$GATEWAY" ]; then

    ip route add 192.168.100.0/24 via "$GATEWAY" 2>/dev/null \

        && echo "Route added successfully" \

        || echo "Route add failed (gateway may not be reachable)"

    ip route show

else

    echo "No default gateway found, skipping"

fi



# ---- 9) mtr ----

log "9) mtr trace to 8.8.8 (report highest latency hop)"

mtr -r -c 5 8.8.8.8



# ---- 10) tcpdump on real interface ----

log "10) tcpdump capture 10 packets on $IFACE"

if [ -n "$IFACE" ]; then

    echo "Capturing 10 packets on $IFACE..."

    echo "Tip: run 'ping google.com' in another terminal to generate traffic"

    tcpdump -i "$IFACE" -c 10 -w capture.pcap 2>/dev/null \

        && echo "Saved to capture.pcap" \

        || echo "tcpdump failed"

    echo "Observation: tcpdump captured raw packets and saved them to capture.pcap."

else

    echo "No interface detected, skipping tcpdump"

fi



log "===== END ====="



echo ""

echo "======================================"

echo "  FINAL OUTPUT (from output.log)"

echo "======================================"

cat output.log
