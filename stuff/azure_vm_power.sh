#!/bin/bash

param=${1}
target_vms=('vmname1' 'vmname2')

if [ -z ${param} ]; then
    echo "param must be required"
    exit 9
fi

if [ ${param} != 'start' -a ${param} != 'stop' ]; then
    echo "param is invalid"
    exit 9
fi

echo -n "Are you really execute ${param} ?"
while read confirm;
do
    case ${confirm} in
        'yes' ) echo "execute vm operation"
            break ;;
        *) echo "abort vm operation"
            exit 9
            break ;;
    esac
done
        
for (( i = 0; i < ${#target_vms[@]}; ++i ))
do
    echo "${param} ${target_vms[$i]}"
    azure vm ${param} ${target_vms[$i]}
done
