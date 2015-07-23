#!/bin/sh

# This script loops through a file of account creds and terminates ONLY LAUNCHING apps in those accounts.


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

	echo "Terminating LAUNCHING apps in account: ${pft_name}/${account_num}"
	${SCRIPT_DIR}/terminate_launching_apps.sh ${account_num} ${rs_host} ${refresh_token} ${app_id}
	
done < ${ACCOUNT_INFO}

