#!/bin/bash
# ===============================================
# Backup Directory by rsync command.
# ===============================================

# Initialize variables
shellName=$0
execDir=$(cd $(dirname $0); pwd)
baseDir=$(dirname ${execDir})

logDir="${baseDir}/log"
logFile="${logDir}/$(date '+%Y%m%d_%H%M%S')_${shellName}.log"
fromDir=""
toDir=""
backupDir=""

echo "$(date '+%Y/%m/%d %T') Start." | tee -a ${logFile}

# Confirm directory exist
if [ ! -d ${fromDir} ];then
    echo "${fromDir} is not exist." | tee -a ${logFile}
    exit 9
fi

if [ ! -d ${toDir} ];then
    echo "${toDir} is not exist." | tee -a ${logFile}
    exit 9
fi

if [ ! -d ${backupDir} ];then
    echo "${backupDir} is not exist." | tee -a ${logFile}   
    exit 9
fi

# Backup process 
echo "$(date '+%Y/%m/%d %T') Start rsync." | tee -a ${logFile}
rsync -av ${fromDir} ${toDir} | tee -a ${logFile}
echo "$(date '+%Y/%m/%d %T') End rsync." | tee -a ${logFile}

echo "$(date '+%Y/%m/%d %T') End." | tee -a ${logFile}
