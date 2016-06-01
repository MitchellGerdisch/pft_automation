#!/bin/sh

# Launches CAT into AWS environment to test things out.

function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM CLOUD_NAME"
	echo "Where CLOUD_NAME is one of AWS, Azure, VMware, Google."
}

if [ $# -ne 2 ]
then
	usage
	exit 1
fi
 
ACCOUNT_NUM="${1}"
CLOUD_NAME="${2}"

# Substring that matches the CAT we want to launch from the catalog.
NAME_MATCH="Corporate Standard Linux"

RSC_TOOL="rsc -a ${ACCOUNT_NUM}"

app_id=`${RSC_TOOL} --xm ":has(.name:contains(\"${NAME_MATCH}\")) > .id" ss index catalog/catalogs/${ACCOUNT_NUM}/applications | sed 's/"//g'`

echo "Launching catalog application id ${app_id} in account ${ACCOUNT_NUM} in ${CLOUD_NAME} environment."

${RSC_TOOL} --pp ss launch /api/catalog/catalogs/${ACCOUNT_NUM}/applications/${app_id} "name=${CLOUD_NAME}_Test_${ACCOUNT_NUM}" "options[][name]=param_location" "options[][type]=string" "options[][value]=${CLOUD_NAME}"

