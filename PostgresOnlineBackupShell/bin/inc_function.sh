#!/bin/bash
# --------------------------------------
# ProgramName	: inc_function.sh
# Outline    	: Functions are defined in this file.
#		: Using this functions, please include this file first.
# --------------------------------------

# --- Function definition
outputLog() {
    LOGGING_DATE=`date '+%Y/%m/%d %H:%M:%S'`
    echo "${LOGGING_DATE} ${1}" | tee -a ${LOG_FILE}
}
