#!/bin/bash
# ============================================
# MythoGyan Graph Sync Cron Script — Enhanced
# ============================================
# Run periodically (via cron or systemd) to keep Neo4j in sync
# ============================================

# --- Script directory ---
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# --- Load environment configuration ---
if [ -f sync_config.env ]; then
  export $(grep -v '^#' sync_config.env | xargs)
else
  echo "❌ sync_config.env not found!"
  exit 1
fi

# --- Timestamp for logging ---
TS=$(date '+%Y-%m-%d %H:%M:%S')

# --- Start log entry ---
echo "[$TS] 🔄 Starting MythoGyan Graph Sync..." >> "$LOG_FILE"

# --- Run Python sync script ---
if [ "$SYNC_MODE" = "FULL" ]; then
    python3 "$SCRIPT_DIR/sync_to_neo4j.py" >> "$LOG_FILE" 2>&1
elif [ "$SYNC_MODE" = "DELTA" ]; then
    echo "[$TS] ⚠️ DELTA sync mode not implemented yet." >> "$LOG_FILE"
else
    echo "[$TS] ⚠️ Unknown SYNC_MODE: $SYNC_MODE" >> "$LOG_FILE"
fi

# --- Check exit status and log ---
if [ $? -eq 0 ]; then
    echo "[$TS] ✅ Sync completed successfully." >> "$LOG_FILE"
else
    echo "[$TS] ⚠️ Sync encountered an error!" >> "$LOG_FILE"
fi
