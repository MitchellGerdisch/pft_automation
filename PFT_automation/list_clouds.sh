#!/bin/sh

# Provides a listing of Clouds from the given account.

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

# Get the list of cloud apps in the account
${RSC_TOOL} --pp cm15 index /api/clouds | grep "\"name\":" | cut -d ":" -f2

