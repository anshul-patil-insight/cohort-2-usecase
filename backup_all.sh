#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="$SCRIPT_DIR"
BASE_DIR="$WORK_DIR/Projects"
SCRIPT_PATH="$WORK_DIR/backup_project.sh"

echo "Starting daily backup wrapper"

mkdir -p "$BASE_DIR"

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "Backup script is not executable: $SCRIPT_PATH"
    exit 1
fi

for project_dir in "$BASE_DIR"/*; do
    if [ -d "$project_dir" ]; then
        echo ""
        echo "Triggering backup for: $project_dir"
        "$SCRIPT_PATH" "$project_dir"
    fi
done

echo ""
echo "All project backups completed"