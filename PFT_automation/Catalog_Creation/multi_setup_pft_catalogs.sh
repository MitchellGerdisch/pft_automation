#!/bin/sh

# This script loops through a file of account creds and coordinates the configuration of a Self-Service catalog for a Premium Free Trial account.


function usage ()
{
	echo "Usage: $0 ACCOUNT_INFO CAT_LIST"
	echo "Where ACCOUNT_INFO is a file containing space-separated list of: PFT Account Name, RightScale Account Number"
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

while read pft_name account_num 
do
	
	echo "Processing Account: ${pft_name}/${account_num}"
	# Create Business Hours Schedule and get it's ID. If already there, no biggy.

	${SCRIPT_DIR}/setup_pft_catalog.sh ${account_num} ${CAT_LIST_FILE}

done < ${ACCOUNT_INFO}

