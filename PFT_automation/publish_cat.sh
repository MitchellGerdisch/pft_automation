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
 
RSC_TOOL="rsc"
ACCOUNT_NUM="${1}"
RIGHTSCALE_HOST="${2}"
REFRESH_TOKEN="${3}"
CAT_ID="${4}"
SCHEDULE_ID="${5}"

tmpfile=/tmp/$RANDOM

${RSC_TOOL} --dump=debug --pp -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss publish /designer/collections/${ACCOUNT_NUM}/templates id="${CAT_ID}" schedules[]=${SCHEDULE_ID} &> $tmpfile
ret_code=$?

if [ $ret_code -eq 2 ]
then
        # Check for conflict and deal with it.
        grep "409 Conflict" $tmpfile &> /dev/null
        if [ $? -eq 0 ]
        then
                # There was a conflict so let's republish with the href of the catalog item to overwrite. 
        	overridden_application_href=`grep "^Location:" $tmpfile | sed 's/  *//g' | cut -d":" -f2` 
		${RSC_TOOL} --dump=debug --pp -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss publish /designer/collections/${ACCOUNT_NUM}/templates id="${CAT_ID}" schedules[]=${SCHEDULE_ID} overridden_application_href="${overridden_application_href}" &> $tmpfile
        fi
elif [ $ret_code -ne 0 ]
then
        echo "Something went wrong. Check your parameters."
        exit 1
fi

rm $tmpfile

echo "CAT ${CAT_ID} published."
