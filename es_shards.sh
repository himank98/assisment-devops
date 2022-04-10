#!/bin/bash
#
FILE=$1
#
# Variables
PRIMARY_NODE_COUNT=0
REPLICA_NODE_COUNT=0
#
TOTAL_PRIMARY_NODE_SIZE=0
TOTAL_REPLICA_NODE_SIZE=0
#
MAX_DISK_SIZE=0
MAX_DISK_SIZE_NODE=''
#
# 80% of 128GB in KB
THRESHOLD_SIZE=107374182
THRESHOLD_CROSSED_NODE=()
# 
PROCESSOR()
{
    TYPE=$1
    SIZE=$2 
    NODE=$3
    if [[ ${TYPE} == 'p' ]]
    then
        ((PRIMARY_NODE_COUNT=PRIMARY_NODE_COUNT+1))
        ((TOTAL_PRIMARY_NODE_SIZE=TOTAL_PRIMARY_NODE_SIZE+SIZE))
    elif [[ ${TYPE} == 'r' ]]
    then
        ((REPLICA_NODE_COUNT=REPLICA_NODE_COUNT+1))
        ((TOTAL_REPLICA_NODE_SIZE=TOTAL_REPLICA_NODE_SIZE+SIZE))
    fi
    if [[ ${SIZE} -gt $MAX_DISK_SIZE ]]
    then
        MAX_DISK_SIZE=${SIZE}
        MAX_DISK_SIZE_NODE=${NODE}
    fi
    if [[ ${SIZE} -gt ${THRESHOLD_SIZE} ]]
    then
        THRESHOLD_CROSSED_NODE+=('${NODE}')
    fi
}
#
while IFS= read -r LINE
do
    TYPE=`echo ${LINE} | awk '{ print $3 }'`
    SIZE=`echo ${LINE} | awk '{if ( $6 ~ /[0-9\.]+tb/ ) printf int($6 * 1024 * 1024 * 1024); else if ( $6 ~ /[0-9\.]+gb/ ) printf int($6 * 1024 * 1024); else if ( $6 ~ /[0-9\.]+mb/ ) printf int($6 * 1024); else if ( $6 ~ /[0-9\.]+kb/ ) printf int($6);}'`
    NODE=`echo ${LINE} | awk '{ print $8 }'`
    PROCESSOR $TYPE $SIZE $NODE
done < "${FILE}"
#
# OUTPUT
echo "count: [primary: ${PRIMARY_NODE_COUNT}, replica: ${REPLICA_NODE_COUNT}]" 
echo
PRETTY_TOTAL_PRIMARY_NODE_SIZE=`numfmt --to=iec --format="%.1f" --from-unit=1024 ${TOTAL_PRIMARY_NODE_SIZE}`
PRETTY_TOTAL_REPLICA_NODE_SIZE=`numfmt --to=iec --format="%.1f" --from-unit=1024 ${TOTAL_REPLICA_NODE_SIZE}`
echo "size: [primary: ${PRETTY_TOTAL_PRIMARY_NODE_SIZE}, replica: ${PRETTY_TOTAL_REPLICA_NODE_SIZE}]" 
echo
echo "disk-max-node: ${MAX_DISK_SIZE_NODE}" 
echo
IFS=','
echo "watermark-breached: [${THRESHOLD_CROSSED_NODE[*]}]"