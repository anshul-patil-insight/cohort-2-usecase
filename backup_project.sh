#!/usr/bin/env bash
set -euo pipefail

echo "Starting backup utility"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-}"
BACKUP_DEST="$HOME/backups"
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/backup_report.txt"
START_TIME="$(date "+%Y-%m-%d %H:%M:%S")"

mkdir -p "$LOG_DIR" "$BACKUP_DEST"

echo "Target directory: $TARGET_DIR"
echo "Validating directory"

if [ -z "$TARGET_DIR" ]; then
    echo "No target directory provided."
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "Source directory does not exist."
    exit 1
fi

if ! TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)"; then
    echo "Could not resolve target directory. Using provided path instead."
fi
PROJECT_NAME="$(basename "$TARGET_DIR")"
STATUS="Success"
WARNINGS="None"
ARCHIVE_NAME="N/A"
ARCHIVE_SIZE="0 MB"

if [ ! -r "$TARGET_DIR" ]; then
    echo "Insufficient permissions."
    STATUS="Failed"
    WARNINGS="Permission denied."
else
    LATEST_BACKUP=$(find "$BACKUP_DEST" -maxdepth 1 -type f -name "${PROJECT_NAME}_backup"*.tar.gz -print 2>/dev/null | sort | tail -n 1)

    if [ -n "$LATEST_BACKUP" ]; then
        echo "Checking for changes since last backup"
        NEW_FILES=$(find "$TARGET_DIR" -type f -newer "$LATEST_BACKUP" | head -n 1)

        if [ -z "$NEW_FILES" ]; then
            echo "No changes detected in $PROJECT_NAME since the last backup. Skipping."
            STATUS="Skipped"
            WARNINGS="No changes detected; backup skipped."
            ARCHIVE_NAME="N/A"
            ARCHIVE_SIZE="0 MB"
        fi
    fi

    if [ "$STATUS" = "Success" ]; then
        echo "Preparing backup"
        ARCHIVE_NAME="${PROJECT_NAME}_backup.tar.gz"
        ARCHIVE_PATH="$BACKUP_DEST/$ARCHIVE_NAME"

        if [ -f "$ARCHIVE_PATH" ]; then
            TIMESTAMP="$(date +%s)"
            ARCHIVE_NAME="${PROJECT_NAME}_backup_${TIMESTAMP}.tar.gz"
            ARCHIVE_PATH="$BACKUP_DEST/$ARCHIVE_NAME"
        fi

        echo "Compressing files"
        if ! tar -czf "$ARCHIVE_PATH" -C "$(dirname "$TARGET_DIR")" "$PROJECT_NAME" 2>/dev/null; then
            WARNINGS="Some files skipped due to read errors."
            STATUS="Failed"
        fi

        if [ -f "$ARCHIVE_PATH" ] && [ "$STATUS" = "Success" ]; then
            ARCHIVE_SIZE="$(du -h "$ARCHIVE_PATH" | awk '{print $1}')"
        elif [ "$STATUS" != "Success" ]; then
            ARCHIVE_SIZE="0 MB"
        fi
    fi
fi

END_TIME="$(date "+%Y-%m-%d %H:%M:%S")"

REPORT="=== Summary ===
Backup Start Time  : $START_TIME
Backup End Time    : $END_TIME
Source Directory   : $TARGET_DIR
Archive Created    : $ARCHIVE_NAME
Archive Size       : $ARCHIVE_SIZE
Backup Location    : $BACKUP_DEST
Status             : $STATUS
Warnings/Errors    : $WARNINGS
================="

echo "$REPORT"
echo "$REPORT" >> "$LOG_FILE"
