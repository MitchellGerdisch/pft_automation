#!/bin/sh

function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM CAT_NAME_MATCH_PATTERN" 
	echo "Where RIGHTSCALE_ACCOUNT_NUM is the account number to work on."
	echo "Where CAT_NAME_MATCH_PATTERN is a string that matches the name of the template/catalog item to remove."
}

if [ $# -ne 2 ]
then
	usage
	exit 1
fi
 
ACCOUNT_NUM="${1}"
NAME_MATCH="${2}"
RSC_TOOL="rsc -a ${ACCOUNT_NUM}"



${RSC_TOOL} --xm ":has(.name:contains(\"${NAME_MATCH}\")) > .href" ss index collections/${ACCOUNT_NUM}/templates | sed "s/\"//g" |
while read href_to_delete
do
	echo "Found HREF to delete: ${href_to_delete}"
	echo ${href_to_delete} | grep designer > /dev/null
	if [ $? -eq 0 ]
	then
		${RSC_TOOL} ss delete ${href_to_delete}
	else
		${RSC_TOOL} ss delete ${href_to_delete}
	fi
done



