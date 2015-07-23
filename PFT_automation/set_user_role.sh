#!/bin/sh

function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM RIGHTSCALE_HOST REFRESH_TOKEN USER_HREF ROLE(S)"
	echo "Where ROLE(S) is(are) one or more RightScale roles surrounded by quotes (e.g. \"observer admin actor\")." 
}

if [ $# -lt 5 ]
then
	usage
	exit 1
fi
 
RSC_TOOL="rsc"
ACCOUNT_NUM="${1}"
RIGHTSCALE_HOST="${2}"
REFRESH_TOKEN="${3}"
USER_HREF="${4}"
ROLES="${5}"

tmpfile=/tmp/$RANDOM

echo "Setting user, ${USER_HREF}, with roles, ${ROLES}"

for ROLE in ${ROLES}
do

	${RSC_TOOL} --pp -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} cm15 create /api/permissions "permission[role_title]=${ROLE}" "permission[user_href]=${USER_HREF}"
done

rm $tmpfile &> /dev/null
