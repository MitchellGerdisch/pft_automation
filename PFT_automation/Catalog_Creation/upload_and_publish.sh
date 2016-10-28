#!/bin/sh

# This script uploads and publishes a CAT file.
# DO NOT USE for package files.


function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM CAT_FILE"
	echo "Where CAT_FILE is the path to a single CAT file."
	exit 1
}

if [ $# -ne 2 ]
then
	usage
	exit 1
fi
 
ACCOUNT_NUM="${1}"
cat_source_file_name="${2}"

SCRIPT_DIR="."
RSC_TOOL="rsc -a ${ACCOUNT_NUM}"

# Find Business Hours Schedule and get it's ID. If already there, no biggy.
schedule_id=`${SCRIPT_DIR}/create_business_hours_schedule.sh ${ACCOUNT_NUM}`

# Upload the file and get it's ID
echo "Uploading CAT: ${cat_source_file_name}"
application_id=`${SCRIPT_DIR}/upload_cat.sh ${ACCOUNT_NUM} "${cat_source_file_name}"`
upload_ret=$?

if [ ${upload_ret} -ne 0 ]
then
	echo "A problem occurred with the upload. Return code: ${upload_ret}. Exiting."
	echo ${application_id}
	exit 2
fi

# Publish the CAT 
echo "Publishing CAT"
${SCRIPT_DIR}/publish_cat.sh ${ACCOUNT_NUM} ${application_id} ${schedule_id}

