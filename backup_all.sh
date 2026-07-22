#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="$SCRIPT_DIR"
BASE_DIR="$WORK_DIR/Projects"
SCRIPT_PATH="$WORK_DIR/backup_project.sh"

echo "Starting daily backup wrapper"

mkdir -p "$BASE_DIR"

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "Backup script is not executable: $SCRIPT_PATH"
    exit 1
fi

shopt -s nullglob
project_dirs=("$BASE_DIR"/*)
shopt -u nullglob

for project_dir in "${project_dirs[@]}"; do
    if [ -d "$project_dir" ]; then
        echo ""
        echo "Triggering backup for: $project_dir"
        if ! "$SCRIPT_PATH" "$project_dir"; then
            echo "Backup failed for: $project_dir"
        fi
    fi
done

echo ""
echo "All project backups completed"
