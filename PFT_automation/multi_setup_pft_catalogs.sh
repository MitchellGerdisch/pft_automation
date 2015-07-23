#!/bin/sh

# This script loops through a file of account creds and coordinates the configuration of a Self-Service catalog for a Premium Free Trial account.


function usage ()
{
	echo "Usage: $0 ACCOUNT_INFO CAT_LIST"
	echo "Where ACCOUNT_INFO is a file containing space-separated list of: PFT Account Name, RightScale Account Number, RightScale Host, Refresh Token"
	echo "Where CAT_LIST is a file containing a list of CAT files to upload."
}

if [ $# -ne 2 ]
then
	usage
	exit 1
fi
 
ACCOUNT_INFO="${1}"
CAT_LIST_FILE="${2}"

SCRIPT_DIR="."
RSC_TOOL="rsc"

while read pft_name account_num rs_host refresh_token
do
	
	echo "Processing Account: ${pft_name}/${account_num}"
	# Create Business Hours Schedule and get it's ID. If already there, no biggy.

	schedule_id=`${SCRIPT_DIR}/create_business_hours_schedule.sh ${account_num} ${rs_host} ${refresh_token}`
	echo "	Created schedule ID: ${schedule_id}"

	while read cat_source_file_name
	do

		echo "	Processing CAT: ${cat_source_file_name}"
		# Upload the CAT and get it's ID
		#echo "Uploading CAT: ${cat_source_file_name}"
		application_id=`${SCRIPT_DIR}/upload_cat.sh ${account_num} ${rs_host} ${refresh_token} "${cat_source_file_name}"`
		echo "	Created application ID: ${application_id}"
	
		# Publish the CAT
		#echo "Publishing CAT"
		${SCRIPT_DIR}/publish_cat.sh ${account_num} ${rs_host} ${refresh_token} ${application_id} ${schedule_id}
		
	done < ${CAT_LIST_FILE}
done < ${ACCOUNT_INFO}

