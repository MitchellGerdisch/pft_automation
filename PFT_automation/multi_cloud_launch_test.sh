#!/bin/sh

# This script launches a given CAT across all PFT clouds for a given account.


function usage ()
{
	echo "Usage: $0 ACCOUNT_NUMBER"
	echo "Where ACCOUNT_NUMBER is the account number."
}

if [ $# -ne 1 ]
then
	usage
	exit 1
fi
 
ACCOUNT_NUMBER="${1}"

SCRIPT_DIR="."

for cloud in AWS Azure Google VMware
do
	echo "Testing ${cloud} environment."
	${SCRIPT_DIR}/cloud_launch_test.sh ${ACCOUNT_NUMBER} ${cloud}
	sleep 3
done 
