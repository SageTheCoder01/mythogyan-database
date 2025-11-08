#!/bin/bash
# ============================================
#  MythoGyan Graph Sync Cron Script
# ============================================
#  Run this periodically (via cron or systemd)
# ============================================

# Directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Load environment configuration
if [ -f sync_config.env ]; then
  export $(grep -v '^#' sync_config.env | xargs)
else
  echo "❌ sync_config.env not found!"
  exit 1
fi

# Timestamp for logging
TS=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$TS] 🔄 Starting MythoGyan Graph Sync..." >> "$LOG_FILE"

# Run Python sync script
/usr/bin/python3 "$SCRIPT_DIR/sync_to_neo4j.py" >> "$LOG_FILE" 2>&1

# Log completion
if [ $? -eq 0 ]; then
  echo "[$TS] ✅ Sync completed successfully." >> "$LOG_FILE"
else
  echo "[$TS] ⚠️ Sync encountered an error!" >> "$LOG_FILE"
fi
