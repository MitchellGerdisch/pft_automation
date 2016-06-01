#!/bin/sh

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

${RSC_TOOL} --pp --xm '.template_info .name' ss index catalog/catalogs/${ACCOUNT_NUM}/applications | sort 


