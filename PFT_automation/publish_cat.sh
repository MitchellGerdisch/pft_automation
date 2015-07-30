#!/bin/sh

function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM CAT_ID SCHEDULE_ID"
}

if [ $# -ne 3 ]
then
	usage
	exit 1
fi
 
ACCOUNT_NUM="${1}"
CAT_ID="${2}"
SCHEDULE_ID="${3}"
RSC_TOOL="rsc -a ${ACCOUNT_NUM}"

tmpfile=/tmp/$RANDOM

echo ${RSC_TOOL} --dump=debug --pp ss publish /designer/collections/${ACCOUNT_NUM}/templates id="${CAT_ID}" schedules[]=${SCHEDULE_ID} &> $tmpfile
exit
${RSC_TOOL} --dump=debug --pp ss publish /designer/collections/${ACCOUNT_NUM}/templates id="${CAT_ID}" schedules[]=${SCHEDULE_ID} &> $tmpfile
ret_code=$?

if [ $ret_code -eq 2 ]
then
        # Check for conflict and deal with it.
        grep "409 Conflict" $tmpfile &> /dev/null
        if [ $? -eq 0 ]
        then
                # There was a conflict so let's republish with the href of the catalog item to overwrite. 
        	overridden_application_href=`grep "^Location:" $tmpfile | sed 's/  *//g' | cut -d":" -f2` 
		${RSC_TOOL} --dump=debug --pp ss publish /designer/collections/${ACCOUNT_NUM}/templates id="${CAT_ID}" schedules[]=${SCHEDULE_ID} overridden_application_href="${overridden_application_href}" &> $tmpfile
        fi
elif [ $ret_code -ne 0 ]
then
        echo "Something went wrong. Check your parameters."
        exit 1
fi

rm $tmpfile

echo "CAT ${CAT_ID} published."
