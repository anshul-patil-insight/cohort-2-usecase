#!/bin/bash

WORK_DIR="/Users/audayaku/Automated-Project-Backup-Utility"
BASE_DIR="$WORK_DIR/Projects"
SCRIPT_PATH="$WORK_DIR/backup_project.sh"

echo "Starting daily backup wrapper"

cd "$WORK_DIR" || exit

for project_dir in "$BASE_DIR"/*; do
    if [ -d "$project_dir" ]; then
        echo ""
        echo "Triggering backup for: $project_dir"
        "$SCRIPT_PATH" "$project_dir"
    fi
 done

echo ""
echo "All project backups completed"