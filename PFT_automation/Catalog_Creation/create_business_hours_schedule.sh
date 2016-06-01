#!/bin/sh

function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM" 
}

if [ $# -ne 1 ]
then
	usage
	exit 1
fi
 
ACCOUNT_NUM="${1}"
RSC_TOOL="rsc -a ${ACCOUNT_NUM}"


${RSC_TOOL} --dump=debug --pp ss create /designer/collections/${ACCOUNT_NUM}/schedules "name=Business Hours" "start_recurrence[hour]=8" "start_recurrence[minute]=0" "start_recurrence[rule]=FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR" "stop_recurrence[hour]=18" "stop_recurrence[minute]=0" "stop_recurrence[rule]=FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR" &> /dev/null
ret_code=$?
if [ $ret_code -eq 1 ]
then
	echo "Something went wrong. Check your parameters."
	exit 1
fi

schedule_id=`${RSC_TOOL} --xm ":has(.name:val(\"Business Hours\")) > .id" --pp ss index /designer/collections/${ACCOUNT_NUM}/schedules | sed 's/"//g'`

printf "$schedule_id"

