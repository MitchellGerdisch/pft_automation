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
 
RSC_TOOL="rsc"
ACCOUNT_NUM="${1}"
RIGHTSCALE_HOST="${2}"
REFRESH_TOKEN="${3}"
FILE_NAME="${4}"

tmpfile=/tmp/$RANDOM

${RSC_TOOL} --dump=debug --pp -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss create collections/${ACCOUNT_NUM}/templates source="${FILE_NAME}" &> $tmpfile
ret_code=$?
if [ $ret_code -eq 0 ]
then
	application_id=`grep "^Location:" $tmpfile | sed 's/  *//g' | cut -d":" -f2 | rev | cut -d"/" -f1 | rev`
elif [ $ret_code -eq 2 ]
then
	# Check for conflict and deal with it.
	grep "409 Conflict" $tmpfile &> /dev/null
	if [ $? -eq 0 ]
	then
		# There was a conflict so let's do an update instead of a create
		# Hack up the file for better parsing
		tr '{' '\n' < $tmpfile > ${tmpfile}_tweaked
		# Now find the application href
		application_id=`grep "application_info" ${tmpfile}_tweaked | sed 's/\}/:/g' | cut -d":" -f2 | sed 's/"//g' | sort -u`
		${RSC_TOOL} --pp -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss update /api/collections/${ACCOUNT_NUM}/templates/${application_id} source="${FILE_NAME}" &> $tmpfile
	fi
else
	echo "Something went wrong. Check your parameters."
	exit 1
fi

printf "$application_id"
rm $tmpfile ${tmpfile}_tweaked &> /dev/null
