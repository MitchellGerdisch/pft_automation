#!/bin/sh

function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM RIGHTSCALE_HOST REFRESH_TOKEN APP_ID"
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
APP_ID="${4}"

echo "**** WARNING WARNING WARNING ****"
echo "YOU WILL TERMINATE ALL RUNNING AND FAILED CLOUD APPLICATIONS IN ACCOUNT ID: ${ACCOUNT_NUM}"
echo ""
echo "Currently the running cloud apps in this account are:"
${RSC_TOOL} --pp  --xm ":has(.status:val(\"running\")) > .name" -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss index manager/projects/${ACCOUNT_NUM}/executions  | sort
echo ""
echo "Currently the failed cloud apps in this account are:"
${RSC_TOOL} --pp  --xm ":has(.status:val(\"failed\")) > .name" -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss index manager/projects/${ACCOUNT_NUM}/executions  | sort

echo ""
echo "****************"
echo "Enter Control-C to EXIT or Enter to continue."
read response

running_app_ids=`${RSC_TOOL} --pp  --xm ":has(.status:val(\"running\")) > .id" -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss index manager/projects/${ACCOUNT_NUM}/executions | sed 's/"//g' | sort | tr '\n' ' '`

echo "Running App IDs to be terminated: ${running_app_ids}"
for app_id in ${running_app_ids}
do
	echo "	Terminating app ID ${app_id}"
	${RSC_TOOL} -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss terminate manager/projects/${ACCOUNT_NUM}/executions/${app_id}
done

echo ""
failed_app_ids=`${RSC_TOOL} --pp  --xm ":has(.status:val(\"failed\")) > .id" -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss index manager/projects/${ACCOUNT_NUM}/executions | sed 's/"//g' | sort | tr '\n' ' '`

echo "Failed App IDs to be terminated: ${failed_app_ids}"
for app_id in ${failed_app_ids}
do
	echo "	Terminating app ID ${app_id}"
	${RSC_TOOL} -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss terminate manager/projects/${ACCOUNT_NUM}/executions/${app_id}
done
echo ""
