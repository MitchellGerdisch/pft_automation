#!/bin/sh

# Launches multiple CAT into given cloud environment to test things out.

function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM CLOUD_NAME CAT_LIST"
	echo "Where RIGHTSCALE_ACCOUNT_NUM is the account number in which you want to launch the CATs."
	echo "Where CLOUD_NAME is one of AWS, Azure, VMware, Google."
	echo "Where CAT_LIST is a file containing SS Catalog names to launch"
}

if [ $# -ne 3 ]
then
	usage
	exit 1
fi
 
ACCOUNT_NUM="${1}"
CLOUD_NAME="${2}"
CAT_LIST="${3}"

# Substring that matches the CAT we want to launch from the catalog.
while read cat_name
do

	NAME_MATCH="${cat_name}"

	RSC_TOOL="rsc -a ${ACCOUNT_NUM}"

	app_id=`${RSC_TOOL} --xm ":has(.name:contains(\"${NAME_MATCH}\")) > .id" ss index catalog/catalogs/${ACCOUNT_NUM}/applications | sed 's/"//g'`

	echo "Launching ${NAME_MATCH} catalog application with id ${app_id} in account ${ACCOUNT_NUM} in ${CLOUD_NAME} environment."

	${RSC_TOOL} --pp ss launch /api/catalog/catalogs/${ACCOUNT_NUM}/applications/${app_id} "name=${CLOUD_NAME}_Test_${ACCOUNT_NUM}" "options[][name]=param_location" "options[][type]=string" "options[][value]=${CLOUD_NAME}"

done < ${CAT_LIST}

