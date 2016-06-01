#!/bin/sh

# This script loops through a file of account numbers and removes the CAT in those accounts with the given name match


function usage ()
{
	echo "Usage: $0 ACCOUNT_INFO CAT_NAME_MATCH"
	echo "Where ACCOUNT_INFO is a file containing space-separated list of: PFT Account Name, RightScale Account Number"
	echo "Where CAT_NAME_MATCH is a string that matches the name of the CAT to delete from the accounts."
}

if [ $# -ne 2 ]
then
	usage
	exit 1
fi
 
ACCOUNT_INFO="${1}"
CAT_NAME_MATCH="${2}"

echo "cat name match: ${CAT_NAME_MATCH}"
SCRIPT_DIR="."

while read pft_name account_num 
do
	
	echo "Deleting the CAT whose name matches, ${CAT_NAME_MATCH} from account: ${pft_name}/${account_num}"
	
	${SCRIPT_DIR}/remove_cat.sh ${account_num} "${CAT_NAME_MATCH}"

done < ${ACCOUNT_INFO}

