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

# Get the list of cloud apps in the account
tmpfile=/tmp/$RANDOM
${RSC_TOOL} ss index manager/projects/${ACCOUNT_NUM}/executions > $tmpfile

echo "Currently the launching cloud apps in this account are:"
cat ${tmpfile} | ${RSC_TOOL} --xm ":has(.status:val(\"launching\")) > .name" json | sort
echo ""

echo "Currently the running cloud apps in this account are:"
cat ${tmpfile} | ${RSC_TOOL} --xm ":has(.status:val(\"running\")) > .name" json | sort
echo ""

echo "Currently the failed cloud apps in this account are:"
cat ${tmpfile} | ${RSC_TOOL} --xm ":has(.status:val(\"failed\")) > .name" json | sort
echo ""


echo "Currently the terminating running cloud apps in this account are:"
cat ${tmpfile} | ${RSC_TOOL} --xm ":has(.status:val(\"terminating\")) > .name" json | sort
echo ""


echo "Currently the terminated cloud apps in this account are:"
cat ${tmpfile} | ${RSC_TOOL} --xm ":has(.status:val(\"terminated\")) > .name" json | sort
echo ""

