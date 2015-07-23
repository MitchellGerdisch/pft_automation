#!/bin/sh

function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM RIGHTSCALE_HOST REFRESH_TOKEN" 
}

if [ $# -ne 3 ]
then
	usage
	exit 1
fi
 
RSC_TOOL="rsc"
ACCOUNT_NUM="${1}"
RIGHTSCALE_HOST="${2}"
REFRESH_TOKEN="${3}"

echo "**** WARNING WARNING WARNING ****"
echo "YOU WILL DELETE ALL TERMINATED CLOUD APPLICATIONS IN ACCOUNT ID: ${ACCOUNT_NUM}"
echo ""
echo "Currently the cloud apps to be deleted are:"

tmpfile=/tmp/$RANDOM
${RSC_TOOL} -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss index manager/projects/${ACCOUNT_NUM}/executions > $tmpfile
app_ids_to_delete=`cat ${tmpfile} | ${RSC_TOOL} --xm ".status:val(\"terminated\") ~ .id" json | sed 's/"//g'`
app_names_to_delete=`cat ${tmpfile} | ${RSC_TOOL} --xm ".status:val(\"terminated\") ~ .name" json`

echo ${app_names_to_delete}
echo ""
echo "****************"
echo "Enter Control-C within 10 seconds to EXIT" 
sleep 10
for app_id in ${app_ids_to_delete}
do
	echo "	Deleting app ID ${app_id}"
	${RSC_TOOL} -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss delete manager/projects/${ACCOUNT_NUM}/executions/${app_id}
done

echo ""
echo "The following apps are still in account ${ACCOUNT_NUM}:"
${RSC_TOOL} --xm ".status ~ .name" -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss index manager/projects/${ACCOUNT_NUM}/executions

rm $tmpfile
