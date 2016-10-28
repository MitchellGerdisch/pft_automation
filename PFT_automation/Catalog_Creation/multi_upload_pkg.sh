#!/bin/sh

# This script loops through a file of account creds and uploads the package files given in the list.
# IT DOES NOT PUBLISH


function usage ()
{
	echo "Usage: $0 ACCOUNT_INFO PKG_FILE"
	echo "Where ACCOUNT_INFO is a file containing space-separated list of: PFT Account Name, RightScale Account Number"
	echo "Where PKG_FILE is the path to the package file to upload"
}

if [ $# -ne 2 ]
then
	usage
	exit 1
fi
 
ACCOUNT_INFO="${1}"
PKG_FILE="${2}"

SCRIPT_DIR="."

while read pft_name account_num 
do
	
	echo "Processing Account: ${pft_name}/${account_num}"

	${SCRIPT_DIR}/upload_cat.sh ${account_num} ${PKG_FILE}

done < ${ACCOUNT_INFO}

