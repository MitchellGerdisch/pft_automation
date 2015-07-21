#!/bin/sh

function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM RIGHTSCALE_HOST REFRESH_TOKEN"
}

if [ $# -ne 3 ]
then
	usage
	exit 1
fi
 
RSC_TOOL="./rsc"
ACCOUNT_NUM="${1}"
RIGHTSCALE_HOST="${2}"
REFRESH_TOKEN="${3}"

${RSC_TOOL} --pp -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} --xm '.template_info .name' ss index catalog/catalogs/81573/applications | sort 


