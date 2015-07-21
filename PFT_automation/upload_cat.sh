#!/bin/sh

function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM RIGHTSCALE_HOST REFRESH_TOKEN CAT_FILE_NAME"
}

if [ $# -ne 4 ]
then
	usage
	exit 1
fi
 
RSC_TOOL="./rsc"
ACCOUNT_NUM="${1}"
RIGHTSCALE_HOST="${2}"
REFRESH_TOKEN="${3}"
FILE_NAME="${4}"

tmpfile=/tmp/$RANDOM

${RSC_TOOL} --dump=debug --pp -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss create collections/${ACCOUNT_NUM}/templates source="${FILE_NAME}" &> $tmpfile
ret_code=$?

if [ $ret_code -eq 1 ]
then
	echo "Something went wrong. Check your parameters."
	exit 1
fi

application_id=`grep "^Location:" $tmpfile | sed 's/  *//g' | cut -d":" -f2 | rev | cut -d"/" -f1 | rev`
printf "$application_id"
rm $tmpfile
