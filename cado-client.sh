#!/bin/sh

SHELL_PATH=$2
masterIP=$1
cadoPort="24242"

cpu_cores=$(lscpu | grep '^CPU(s):' | awk '{print $2}')
processes=$(( cpu_cores / 2 ))
basepath="/tmp/dreadpool/$(uuidgen)"
hostnm=$hostname

find $basepath -mindepth 1 -maxdepth 1 -mmin +20 -type d -name '*.work' -exec rm -rf {} \;
find $basepath/download -mindepth 1 -maxdepth 1 -mmin +20 -type d -name 'WU.*' -exec rm -rf {} \;

cd $SHELL_PATH
if [ $(ps augx | grep "cado-nfs-client.py"  | grep "$masterIP" | grep -v "grep" | wc -l) -ne 0 ]; then
        ps augx | grep "cado-nfs-client.py"  | grep "$masterIP" | grep -v "grep" | awk '{print $2}' | xargs kill
fi
        
if [ ! -d $basepath ] ; then
        mkdir $basepath -p
fi
if [ ! -d $basepath/download ] ; then
        mkdir $basepath/download -p
fi
if [ $(ps augx | grep "cado-nfs-client.py"  | grep "$masterIP" | grep -v "grep" | wc -l) -ne $processes ]; then
        ps augx | grep "cado-nfs-client.py"  | grep "$masterIP" | grep -v "grep" | awk '{print $2}' | xargs kill
        for process_seq in $(seq 0 $((processes-1))); do
                ./cado-nfs-client.py --daemon --server=http://$masterIP:$cadoPort --bindir $(eval `make show` ; echo $build_tree) --basepath=$basepath
        done
fi
