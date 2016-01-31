#!/bin/bash

# ---------------------------
# azureControl.sh
# arm(リソースマネジャデプロイモデル)でデプロイされているvmの起動、停止を行う
# ※事前にazure loginで認証が必要
# ---------------------------
ctl=$1

# start, stopの場合で、起動、停止する仮想マシンの順序を決定
if [ ${ctl} = "start" ]; then
    vms=("cent6-01" "cent6-02" "cent6-03" "pgpool")
elif [ ${ctl} = "stop" ]; then
    vms=("cent6-01" "cent6-02" "cent6-03" "pgpool")
else
    # start, stop以外の場合はエラー
    echo "invalid parameter"
    exit 1
fi

# 設定された仮想マシン分ループ処理
for vm in "${vms[@]}"; do
    echo ${vm}
    azure vm ${ctl} DEVENV ${vm}
done