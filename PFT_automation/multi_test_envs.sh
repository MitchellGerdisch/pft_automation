#!/bin/sh

# This script launches the linux server CAT in the VMware environment across the accounts in the ACCOUNT_INFO file.


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
	echo "Testing environment for account: ${pft_name}/${account_num}"
	${SCRIPT_DIR}/launch_test.sh ${account_num} ${rs_host} ${refresh_token} 
	sleep 5
done < ${ACCOUNT_INFO}
