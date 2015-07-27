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

echo "Here is a list of all CloudApps in account ${ACCOUNT_NUM}:"
${RSC_TOOL} --xm ".status ~ .name" ss index manager/projects/${ACCOUNT_NUM}/executions

echo "Currently the running cloud apps in this account are:"
${RSC_TOOL} --pp  --xm ":has(.status:val(\"running\")) > .name" ss index manager/projects/${ACCOUNT_NUM}/executions  | sort
echo ""
echo "Currently the failed cloud apps in this account are:"
${RSC_TOOL} --pp  --xm ":has(.status:val(\"failed\")) > .name" ss index manager/projects/${ACCOUNT_NUM}/executions  | sort

