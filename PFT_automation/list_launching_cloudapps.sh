#!/bin/sh

# Provides a listing of CloudApps from the given account.

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

echo "Here is a list of all LAUNCHING CloudApps in account ${ACCOUNT_NUM}:"
${RSC_TOOL} --pp  --xm ":has(.status:val(\"launching\")) > .name" ss index manager/projects/${ACCOUNT_NUM}/executions  | sort
echo ""

