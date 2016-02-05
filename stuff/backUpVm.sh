#/bin/bash
# =====================================
# kvm vms backup
# =====================================
export LIBVIRT_DEFAULT_URI="qemu:///system"
bkupFromDir=/mnt/hdd/d2p1/kvmMainStorage
bkupToDir=/mnt/hdd/d1p3/bkup/kvm

# config
vms=(docker jenkins)
vols=(docker_vol01.qcow2 jenkins_vol01.qcow2)

for (( i=0; i<${#vms[@]}; i++ ))
do
    echo "----------"
    echo "`date` ${vms[i]}"
    # dumpxml
    virsh dumpxml ${vms[i]} > ${bkupToDir}/${vms[i]}.xml
    ret=$?
    if [ ${ret} -ne 0 ]; then
        echo "failed to dumpxml for ${vms[i]}"
        continue
    fi

    # stop vm
    virsh shutdown ${vms[i]}
    ret=$?
    if [ ${ret} -ne 0 ]; then
        echo "failed to shutdown for ${vms[i]}"
        continue
    fi
    sleep 15

    # backup vm image
    sudo cp -p "${bkupFromDir}/${vols[i]}" "${bkupToDir}/${vols[i]}"
    ret=$?
    if [ ${ret} -ne 0 ]; then
        echo "failed to copy image for ${vms[i]}"
        continue
    fi

    echo "success to bkup ${vms[i]}"

    # start vm
    virsh start ${vms[i]}
    ret=$?
    if [ ${ret} -ne 0 ]; then
        echo "failed to start for ${vms[i]}"
        continue
    fi

    echo "success to start ${vms[i]}"
done
