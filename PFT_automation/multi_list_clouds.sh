#!/bin/sh

# This script loops through a file of account numbers and lists the clouds registered to that account.


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

	echo "Clouds Registered in RightScale Account: ${pft_name}/${account_num}"
	${SCRIPT_DIR}/list_clouds.sh ${account_num} 
	echo ""
	echo "#########"
	echo ""
	
done < ${ACCOUNT_INFO}

