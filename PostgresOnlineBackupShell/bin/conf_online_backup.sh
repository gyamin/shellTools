#!/bin/bash
BIN_DIR=$(cd $(dirname $0); pwd)
# --- Log variable setting
# setting following log variable, logging log file.
LOG_DIR="$(dirname ${BIN_DIR})/log"
LOG_FILE="${LOG_DIR}/$(date '+%Y%m%d%H%M%S')_PostgreOnlineBackup.log"
# --- PostgreSQL variable setting
# Designate PostgreSQL Cluster directory
PG_DATA="/var/lib/pgsql/9.2/data"
# Designate directory where online backup file are reserved
BACKUP_RESERVED_DIR="/var/lib/pgsql/9.2/backups"
# Designate archive WAL direcotry
ARCHIVE_WAL_DIR="/var/lib/pgsql/9.2/wal_archive"
