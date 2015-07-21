#!/bin/sh

function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM RIGHTSCALE_HOST REFRESH_TOKEN CAT_ID SCHEDULE_ID"
}

if [ $# -ne 5 ]
then
	usage
	exit 1
fi
 
RSC_TOOL="./rsc"
ACCOUNT_NUM="${1}"
RIGHTSCALE_HOST="${2}"
REFRESH_TOKEN="${3}"
CAT_ID="${4}"
SCHEDULE_ID="${5}"

tmpfile=/tmp/$RANDOM

${RSC_TOOL} --dump=debug --pp -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss publish /designer/collections/${ACCOUNT_NUM}/templates id="${CAT_ID}" schedules[]=${SCHEDULE_ID} &> $tmpfile
ret_code=$?

if [ $ret_code -eq 1 ]
then
	echo "Something went wrong. Check your parameters."
	exit 1
fi

rm $tmpfile

echo "CAT ${CAT_ID} published."
