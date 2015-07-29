#!/bin/sh

# Launches specified catalog item into given environment to test things out.
# PREREQUISITE: 
#	rsc setup has been run to set the username, password and host that can be used with the given account.

function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM CLOUD_NAME APP_TITLE [param_name:param_type:param_value]"
	echo "Where CLOUD_NAME is one of AWS, Azure, VMware, Google."
	echo "Where APP_TITLE is any string that will match uniquely the application name as it appears in the catalog"
	echo "Where param_name:param_type:param_value are optional colon-separated sets of parameters for the cloud application enclosed in quotes."
}

if [ $# -lt 3 ]
then
	usage
	exit 1
fi
 
ACCOUNT_NUM="${1}"
CLOUD_NAME="${2}"
# Substring that matches the CAT we want to launch from the catalog.
NAME_MATCH="${3}"
PARAMS="${4}"
ADDITIONAL_OPTIONS=""
for param_set in ${PARAMS} 
do
	param_name=`echo ${param_set} | cut -d":" -f1`
	param_type=`echo ${param_set} | cut -d":" -f2`
	param_value=`echo ${param_set} | cut -d":" -f3`

	ADDITIONAL_OPTIONS="$ADDITIONAL_OPTIONS "options[][name]=${param_name}" "options[][type]=${param_type}" "options[][value]=${param_value}""

done

# a little time stamp to use in app name
timestamp=`date +"%H%M"`

RSC_TOOL="rsc -a ${ACCOUNT_NUM}"

app_id=`${RSC_TOOL} --xm ":has(.name:contains(\"${NAME_MATCH}\")) > .id" ss index catalog/catalogs/${ACCOUNT_NUM}/applications | sed 's/"//g'`

echo "Launching catalog application id ${app_id} in account ${ACCOUNT_NUM} in ${CLOUD_NAME} environment."

${RSC_TOOL} --pp ss launch /api/catalog/catalogs/${ACCOUNT_NUM}/applications/${app_id} "name=${CLOUD_NAME}_${NAME_MATCH}_Test_${timestamp}_${ACCOUNT_NUM}" "options[][name]=param_location" "options[][type]=string" "options[][value]=${CLOUD_NAME}" ${ADDITIONAL_OPTIONS}

