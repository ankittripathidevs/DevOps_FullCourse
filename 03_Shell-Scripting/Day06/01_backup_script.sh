#!/bin/bash

# ============================================================
# Backup Script
# Creates a ZIP backup and keeps only the latest 5 backups.
#
# Usage:
#   ./01_backup_script.sh <source_directory> <backup_directory>
# ============================================================

# Stop script if a command fails
set -e

# ------------------------------------------------------------
# Configuration & Variables
# ------------------------------------------------------------

# Maximum number of backups to keep
MAX_BACKUPS=5

# Assign Arguments
SOURCE_DIR="$1"    # 
BACKUP_DIR="$2"

# Timestamp in Indian Standard Time
TIMESTAMP=$(TZ=Asia/Kolkata date "+%Y-%m-%d_%H-%M-%S")


# ------------------------------------------------------------
# Check arguments
# ------------------------------------------------------------

if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_directory> <backup_directory>"
    exit 1
fi


# ------------------------------------------------------------
# Validate source directory
# ------------------------------------------------------------

if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory does not exist: $SOURCE_DIR"
    exit 1
fi


# ------------------------------------------------------------
# Check if zip is installed
# ------------------------------------------------------------

if ! command -v zip >/dev/null 2>&1; then
    echo "ERROR: zip is not installed."
    echo "Install it using: sudo apt install zip -y"
    exit 1
fi


# ------------------------------------------------------------
# Create Backup
# ------------------------------------------------------------

create_backup() {

    BACKUP_FILE="${BACKUP_DIR}/backup-completed_${TIMESTAMP}.zip"

    echo "Creating backup..."

    zip -rq "$BACKUP_FILE" "$SOURCE_DIR"

    echo "Backup created successfully: $BACKUP_FILE"
}

create_backup


# ------------------------------------------------------------
# Backup Rotation
# Keep only the latest 5 backups
# ------------------------------------------------------------

perform_rotation() {
    echo "Performing backup rotation..."

    ls -1t "$BACKUP_DIR"/backup-completed_*.zip |
        tail -n +$((MAX_BACKUPS + 1)) |
        xargs -r rm --

    echo "Backup rotation completed."
    echo "Latest $MAX_BACKUPS backups are retained."
}

perform_rotation


# ==============================================================
#         Notes for future understanding
# ==============================================================

<< 'Notes'
# $#            → number of arguments passed to the script
# -ne           → not equal
# command -v    → checks whether a command is available
# >/dev/null    → hide normal output
# 2>&1          → hide error output
# ls -1t        → list files, newest first
# $((...))      → Bash arithmetic
# tail -n +6    → output from line 6 onward
# xargs         → passes output as arguments to another command
# rm --         → safely removes the files passed to rm
# |             → pipe output of one command into another
Notes

# ===============================================================
