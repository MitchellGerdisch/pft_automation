#!/bin/sh

if [ $# -ne 2 ]
then
	echo "USAGE: $0 ACCOUNT_NUMBER USER_HREF"
	echo "Where ACCOUNT_NUMBER is the account number to which to add the users."
	echo "Where USER_HREF is the HREF for a given user that ALREADY has a RightScale account."
	exit 1
fi

ACCOUNT_NUMBER=${1}
USER_HREF=${2}

# Check to see that the rsc tool is installed.
rsc --version > /dev/null
if [ $? -ne 0 ]
then
	echo "Go to https://github.com/rightscale/rsc/blob/master/README.md and install the rsc tool for your OS."
	echo "And, run rsc setup"
	exit 1
fi

echo "Confirm you want to add the user to account ${ACCOUNT_NUMBER} with all permissions (y/n)"
read resp
if [ ${resp} != "y" ]
then
	echo "EXITING"
	exit 1
fi

# Give the user all permissions - it's a PFT after all
for role in observer actor server_login admin publisher designer billing server_superuser library security_manager
do
	# redirect to /dev/null so that duplicate attempt messages are not echoed to the user
	rsc --pp -a ${ACCOUNT_NUMBER} cm15 create /api/permissions "permission[role_title]=${role}" "permission[user_href]=${USER_HREF}" &> /dev/null
done
