#!/bin/sh

function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM USER_HREF ROLE(S)"
	echo "Where ROLE(S) is(are) one or more RightScale roles surrounded by quotes (e.g. \"observer admin actor\")." 
}

if [ $# -lt 3 ]
then
	usage
	exit 1
fi
 
ACCOUNT_NUM="${1}"
USER_HREF="${2}"
ROLES="${3}"
RSC_TOOL="rsc -a ${ACCOUNT_NUM}"

tmpfile=/tmp/$RANDOM

echo "Setting user, ${USER_HREF}, with roles, ${ROLES}"

for ROLE in ${ROLES}
do

	${RSC_TOOL} --pp cm15 create /api/permissions "permission[role_title]=${ROLE}" "permission[user_href]=${USER_HREF}"
done

rm $tmpfile &> /dev/null
