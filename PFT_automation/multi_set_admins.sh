#!/bin/sh

# This script loops through a file of account creds and a list of SDRs and gives them admin and actor permissions in those accounts.


function usage ()
{
	echo "Usage: $0 ACCOUNT_INFO SDR_LIST" 
	echo "Where ACCOUNT_INFO is a file containing space-separated list of: PFT Account Name, RightScale Account Number"
	echo "Where SDR_LIST is a file containing space-separated list of: SDR email, SDR user href."
}

if [ $# -ne 2 ]
then
	usage
	exit 1
fi
 
ACCOUNT_INFO="${1}"
SDR_LIST="${2}"

SCRIPT_DIR="."

while read pft_name account_num 
do

	while read user_email user_href
	do
		echo ""
		echo "Setting observer, actor and admin roles for ${user_email} in account ${pft_name}"
		${SCRIPT_DIR}/set_user_role.sh ${account_num} ${user_href} 'observer actor admin'
	done < ${SDR_LIST}
	
done < ${ACCOUNT_INFO}

