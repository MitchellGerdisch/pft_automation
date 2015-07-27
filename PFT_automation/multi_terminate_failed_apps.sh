#!/bin/sh

# This script loops through a file of account creds and terminates ONLY failed apps in those accounts.


function usage ()
{
	echo "Usage: $0 ACCOUNT_INFO" 
	echo "Where ACCOUNT_INFO is a file containing space-separated list of: PFT Account Name, RightScale Account Number"
}

if [ $# -ne 1 ]
then
	usage
	exit 1
fi
 
ACCOUNT_INFO="${1}"

SCRIPT_DIR="."

while read pft_name account_num 
do

	echo "Terminating FAILED apps in account: ${pft_name}/${account_num}"
	${SCRIPT_DIR}/terminate_failed_apps.sh ${account_num} 
	
done < ${ACCOUNT_INFO}

