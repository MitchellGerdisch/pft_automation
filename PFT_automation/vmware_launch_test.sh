#!/bin/sh

# Launches CAT into AWS and VMware environment to test things out.

function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM RIGHTSCALE_HOST REFRESH_TOKEN"
}

if [ $# -ne 3 ]
then
	usage
	exit 1
fi
 
RSC_TOOL="rsc"
ACCOUNT_NUM="${1}"
RIGHTSCALE_HOST="${2}"
REFRESH_TOKEN="${3}"

# Substring that matches the CAT we want to launch from the catalog.
NAME_MATCH="Corporate Standard Linux"

app_id=`${RSC_TOOL} --xm ":has(.name:contains(\"${NAME_MATCH}\")) > .id" -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss index catalog/catalogs/${ACCOUNT_NUM}/applications | sed 's/"//g'`

echo "Launching catalog application id ${app_id} in account ${ACCOUNT_NUM} in VMware environment."

${RSC_TOOL} --pp -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss launch /api/catalog/catalogs/${ACCOUNT_NUM}/applications/${app_id} "name=VMwareTest_${ACCOUNT_NUM}" "options[][name]=param_location" "options[][type]=string" "options[][value]=VMware"
