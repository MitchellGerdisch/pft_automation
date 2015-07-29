#!/bin/sh

# This script coordinates the configuration of a Self-Service catalog for a Premium Free Trial account.


function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM CAT_LIST_FILE"
	echo "Where CAT_LIST_FILE is a file containing a list of paths to CATs to be uploaded and published."
}

if [ $# -ne 2 ]
then
	usage
	exit 1
fi
 
ACCOUNT_NUM="${1}"
CAT_LIST_FILE="${2}"

SCRIPT_DIR="."
RSC_TOOL="rsc -a ${ACCOUNT_NUM}"

# Create Business Hours Schedule and get it's ID. If already there, no biggy.
schedule_id=`${SCRIPT_DIR}/create_business_hours_schedule.sh ${ACCOUNT_NUM}`

while read cat_source_file_name
do

	# Upload the CAT and get it's ID
	echo "Uploading CAT: ${cat_source_file_name}"
	application_id=`${SCRIPT_DIR}/upload_cat.sh ${ACCOUNT_NUM} "${cat_source_file_name}"`

	# Publish the CAT
	echo "Publishing CAT"
	${SCRIPT_DIR}/publish_cat.sh ${ACCOUNT_NUM} ${application_id} ${schedule_id}
	
done < ${CAT_LIST_FILE}

echo ""
echo "Here is the SS Catalog as it now stands:"
${SCRIPT_DIR}/list_catalog_app_names.sh ${ACCOUNT_NUM} 
