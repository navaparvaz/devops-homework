#!/bin/bash



# ==========================================

# Section 2 - Filter Commands

# Run + Log + Show  (all in one)

# ==========================================



# Save all output to output.log

exec > >(tee output.log) 2>&1



# Simple log function

log() {

    echo "[$(date '+%H:%M:%S')] $1"

}



log "===== START ====="



# ---------- Create input files ----------

log "Creating employees.txt"

cat > employees.txt <<'EOF'

101,Alice,Engineering

102,Bob,Marketing

103,Charlie,Engineering

104,Diana,HR

105,Ethan,Marketing

EOF



log "Creating salaries.txt"

cat > salaries.txt <<'EOF'

101,5000

102,4500

103,6000

104,5200

105,4800

EOF



# ---------- TASKS ----------



log "1) nl - number the lines of employees.txt"

nl employees.txt



log "2) wc - count lines, words, characters"

wc employees.txt



log "3) tr - convert lowercase to uppercase"

tr 'a-z' 'A-Z' < employees.txt



log "4) tr - replace commas with tabs"

tr ',' '\t' < employees.txt



log "5) paste - merge side by side with colon"

paste -d ':' employees.txt salaries.txt



log "6) join - combine on employee ID"

join -t, employees.txt salaries.txt



log "7) xargs - create file1.txt to file5.txt"

seq 1 5 | xargs -I{} touch file{}.txt

ls file*.txt



log "8) xargs + grep - search Engineering in .txt files"

ls *.txt | xargs grep "Engineering"



log "===== END ====="



# ---------- SHOW OUTPUT ----------

echo ""

echo "======================================"

echo "  FINAL OUTPUT (from output.log)"

echo "======================================"

cat output.log
