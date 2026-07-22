#!/bin/bash

echo "Starting backup utility"

TARGET_DIR="$1"
BACKUP_DEST="$HOME/backups"
LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/backup_report.txt"
START_TIME=$(date "+%Y-%m-%d %H:%M:%S")

mkdir -p "$LOG_DIR"
mkdir -p "$BACKUP_DEST"

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

if [ ! -r "$TARGET_DIR" ]; then
    echo "Insufficient permissions."
    STATUS="Failed"
    WARNINGS="Permission denied."
    ARCHIVE_NAME="N/A"
    ARCHIVE_SIZE="0 MB"
else
    STATUS="Success"
    WARNINGS="None"
    PROJECT_NAME=$(basename "$TARGET_DIR")
    
    LATEST_BACKUP=$(ls -t "$BACKUP_DEST/${PROJECT_NAME}_backup"*.tar.gz 2>/dev/null | head -n 1)

    if [ -n "$LATEST_BACKUP" ]; then
        echo "Checking for changes since last backup"
        NEW_FILES=$(find "$TARGET_DIR" -newer "$LATEST_BACKUP" | head -n 1)
        
        if [ -z "$NEW_FILES" ]; then
            echo "No changes detected in $PROJECT_NAME since the last backup. Skipping."
            exit 0
        fi
    fi

    echo "Preparing backup"
    ARCHIVE_NAME="${PROJECT_NAME}_backup.tar.gz"
    ARCHIVE_PATH="$BACKUP_DEST/$ARCHIVE_NAME"

    if [ -f "$ARCHIVE_PATH" ]; then
        TIMESTAMP=$(date "+%Y-%m-%d")
        TIME=$(date "+%H-%M-%S")
    
        ARCHIVE_NAME="${PROJECT_NAME}-${TIMESTAMP}-${TIME}.tar.gz"
        ARCHIVE_PATH="$BACKUP_DEST/$ARCHIVE_NAME"
    fi

    echo "Compressing files"
    tar -czf "$ARCHIVE_PATH" -C "$(dirname "$TARGET_DIR")" "$PROJECT_NAME" 2>/dev/null
    
    if [ $? -ne 0 ]; then
        WARNINGS="Some files skipped due to read errors."
    fi

    if [ -f "$ARCHIVE_PATH" ]; then
        ARCHIVE_SIZE=$(du -h "$ARCHIVE_PATH" | awk '{print $1}')
    else
        STATUS="Failed"
        WARNINGS="Archive creation failed."
        ARCHIVE_SIZE="0 MB"
    fi
fi

END_TIME=$(date "+%Y-%m-%d %H:%M:%S")

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
