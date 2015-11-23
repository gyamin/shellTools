#!/bin/bash
# -----------------------------------------------
# PROGRAM_NAME  : delDiscardedFile
# OUTLINE       : ファイル削除ディレクトリから、ファイル名が正規表現に一致するファイルを、保持世代数を残して削除する。
# AUTHOR        : Y.Nogami
# PARAMETER     : $1 ファイル削除ディレクトリ
#               : $2 削除対象ファイル名正規表現
#               : $3 保持世代数
#               : $4 ログファイル
# -----------------------------------------------

# 初期変数設定
if [ $# -lt 3 ] || [ $# -gt 4 ]; then
    echo "引数に誤りがあります。"
    exit 90
fi
DIR=$1
REGEXP=$2
RESERVED_FILE_NUM=$3
if [ -z $4 ]; then
    LOG=$4
else
    LOG=/dev/null
fi

TARGET_FILES=(`ls -tr ${DIR} | grep ".*${REGEXP}.*"`)
CNT_TARGET_FILES=${#TARGET_FILES[*]}
CNT_DEL_FILES=`expr ${CNT_TARGET_FILES} - ${RESERVED_FILE_NUM}`

if [ ${CNT_DEL_FILES} -gt 0 ]; then
    i=0
    while [ ${i} -lt ${CNT_DEL_FILES} ];
    do
        echo "削除:${DIR}/{TARGET_FILES[$i]}" | tee -a ${LOG}
        rm -f ${DIR}/${TARGET_FILES[$i]}
        i=`expr ${i} + 1`
    done
fi
exit 0
