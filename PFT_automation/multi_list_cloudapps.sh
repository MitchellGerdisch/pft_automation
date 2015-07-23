#!/bin/sh

# This script loops through a file of account creds and lists the apps in that account.


function usage ()
{
	echo "Usage: $0 ACCOUNT_INFO" 
	echo "Where ACCOUNT_INFO is a file containing space-separated list of: PFT Account Name, RightScale Account Number, RightScale Host, Refresh Token"
}

if [ $# -ne 1 ]
then
	usage
	exit 1
fi
 
ACCOUNT_INFO="${1}"

SCRIPT_DIR="."
RSC_TOOL="rsc"

while read pft_name account_num rs_host refresh_token
do

	echo "CloudApp Info for Account: ${pft_name}/${account_num}"
	${SCRIPT_DIR}/list_cloudapps.sh ${account_num} ${rs_host} ${refresh_token} ${app_id}
	echo ""
	echo "#########"
	echo ""
	
done < ${ACCOUNT_INFO}

