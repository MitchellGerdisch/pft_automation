#!/bin/sh

# This script launches a CAT in the given cloud environment across the accounts in the ACCOUNT_INFO file.


function usage ()
{
	echo "Usage: $0 ACCOUNT_INFO CLOUD_NAME"
	echo "Where ACCOUNT_INFO is a file containing space-separated list of: PFT Account Name, RightScale Account Number"
	echo "Where CLOUD_NAME is one of AWS, Azure, VMware, Google."
}

if [ $# -ne 2 ]
then
	usage
	exit 1
fi
 
ACCOUNT_INFO="${1}"
CLOUD_NAME="${2}"

SCRIPT_DIR="."

while read pft_name account_num 
do
	echo "Testing ${CLOUD_NAME} environment for account: ${pft_name}/${account_num}"
	${SCRIPT_DIR}/cloud_launch_test.sh ${account_num} ${CLOUD_NAME}
	sleep 3
done < ${ACCOUNT_INFO}
