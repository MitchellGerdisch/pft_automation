#!/bin/sh

function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM PKG_FILE_NAME"
}

if [ $# -ne 2 ]
then
	usage
	exit 1
fi
 
ACCOUNT_NUM="${1}"
FILE_NAME="${2}"
RSC_TOOL="rsc -a ${ACCOUNT_NUM}"

tmpfile=/tmp/$RANDOM


# Identify the package this file provides
pkg_name=`grep "package" $FILE_NAME | cut -d " " -f2 | sed 's/\"//g'`

# Find any dependents of this package file so you can later recompile/republish them.
${RSC_TOOL} 

${RSC_TOOL} --dump=debug --pp ss create collections/${ACCOUNT_NUM}/templates source="${FILE_NAME}" &> $tmpfile
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
		${RSC_TOOL} --pp ss update /api/collections/${ACCOUNT_NUM}/templates/${application_id} source="${FILE_NAME}" &> $tmpfile
	fi
else
	echo "Something went wrong. Look at $tmpfile."
	exit 2
fi

if [ -z $application_id ]
then
	echo "Something went wrong uploading the application - look at the end of $tmpfile for details"
	exit 3
fi
printf "$application_id"
rm $tmpfile ${tmpfile}_tweaked &> /dev/null
exit 0
