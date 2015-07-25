#!/bin/bash
# --------------------------------------
# ProgramName: doOnlineBackup.sh
# Params     : 
# Outline    : Make PostgreSQL online backup base.
# --------------------------------------

source conf_online_backup.sh
source inc_function.sh

PGRET=0
# --- Check 
if [ -z ${LOG_FILE} ]; then
    LOG_FILE="/dev/null"
fi

if [ ! -d ${PG_DATA} ]; then
    outputLog "\"${PG_DATA}\" does not exist." 
    PGRET=9 
    exit ${PGRET} 
fi

if [ ! -d ${BACKUP_RESERVED_DIR} ]; then
    outputLog "\"${BACKUP_RESERVED_DIR}\" does not exist." 
    PGRET=9 
    exit ${PGRET} 
fi

if [ ! -d ${ARCHIVE_WAL_DIR} ]; then
    outputLog "\"${ARCHIVE_WAL_DIR}\" does not exist." 
    PGRET=9 
    exit ${PGRET} 
fi

# -- Make Online Backup
outputLog "START ONLINE BACKUP"

# --- Make backup temp directory
outputLog "make backup temp directory."
TEMP_DIR_PREFIX=`date '+%Y%m%d%H%M%S'`ONLINE_BACKUP
BACKUP_TEMP_DIR=${BACKUP_RESERVED_DIR}/${TEMP_DIR_PREFIX}
mkdir -p ${BACKUP_TEMP_DIR}
if [ $? -ne 0 ]; then
    outputLog "Failed to make \"${BACKUP_TEMP_DIR}\"."
    PGRET=9
    exit ${PGRET}
fi
# --- Call pg_start_backup
outputLog "call pg_start_backup."
psql -c "SELECT pg_start_backup(now()::text)" >> ${LOG_FILE} 2>&1
if [ $? -ne 0 ]; then
    outputLog "Failed to call \"pg_stat_backup()\"."
    PGRET=9
    exit ${PGRET}
fi

# --- rsync PG_DATA
outputLog "rsync PG_DATA."
rsync -a --delete --exclude=pg_xlog --exclude=postmaster.pid ${PG_DATA}/* ${BACKUP_TEMP_DIR} >> ${LOG_FILE} 2>&1
if [ $? -ne 0 ]; then
    outputLog "Failed to rsync \"${PG_DATA}\"."
    PGRET=9
    exit ${PGRET}
fi

# --- Call pg_stop_backup
outputLog "call pg_stop_backup."
psql -c "SELECT pg_stop_backup()" >> ${LOG_FILE} 2>&1
if [ $? -ne 0 ]; then
    outputLog "Failed to call \"pg_stop_backup()\"."
    PGRET=9
    exit ${PGRET}
fi

# --- Archive backup files
outputLog "archive backuped files."
cd ${BACKUP_RESERVED_DIR}
tar cfz ${BACKUP_TEMP_DIR}.tar.gz ${TEMP_DIR_PREFIX} >> ${LOG_FILE} 2>&1
if [ $? -ne 0 ]; then
    outputLog "Failed to archive \"${BACKUP_TEMP_DIR}\"."
    PGRET=9
    exit ${PGRET}
fi
cd ${BIN_DIR}

# --- Delete archive wal files
outputLog "delete archive wal files."
BACKUP_LABEL_FILE=${BACKUP_TEMP_DIR}/backup_label
cat ${BACKUP_LABEL_FILE} >> ${LOG_FILE}
# get START WAL LOCATION file
START_WAL_FILE_NAME=$(cat ${BACKUP_LABEL_FILE} | grep "START WAL LOCATION" | sed -e 's/START WAL LOCATION:.*.file \|)//g')
START_WAL_FILE=${ARCHIVE_WAL_DIR}/${START_WAL_FILE_NAME}

TEMP_FILE="$(date '+%Y%m%d%H%M%S')deletefiles"
find ${ARCHIVE_WAL_DIR} -type f > ${TEMP_FILE}

while read LINE
do
    if [ -f ${START_WAL_FILE} -a -f ${LINE} ]; then
        if [ ${LINE} -ot ${START_WAL_FILE} ]; then
            echo ${LINE} >> ${LOG_FILE}
            rm -f ${LINE}
        fi 
    fi
done < ${TEMP_FILE}

rm -f ${TEMP_FILE}
rm -rf ${BACKUP_TEMP_DIR}
outputLog "END ONLINE BACKUP"
