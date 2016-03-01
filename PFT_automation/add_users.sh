#!/bin/sh

echo "ONLY USE THIS TOOL IF AT LEAST ONE PERSON FROM THE COMPANY HAS ALREADY GONE THROUGH THE ON-LINE REGISTRATION."
echo "Has a user from the company already done the on-line registration? (y/n)"
read reg_answer
if [ ${reg_answer} != "y" ]
then
    echo "Need at least one person from the company to have clicked through the online registration process."
    exit 2
 fi

if [ $# -ne 2 ]
then
	echo "USAGE: $0 ACCOUNT_NUMBER USERS_FILE"
	echo "Where ACCOUNT_NUMBER is the account number to which to add the users."
	echo "Where USERS_FILE is a file containing user entries of the form:"
	echo "   FirstName,LastName,CompanyName,EmailAddress,PhoneNumber,Password"
	exit 1
fi

ACCOUNT_NUMBER=${1}
USERS_FILE=${2}

if [ -z ${USERS_FILE} ]
then
	echo "Can't find, ${USERS_FILE}"
	exit 1
fi

# Check to see that the rsc tool is installed.
rsc --version > /dev/null
if [ $? -ne 0 ]
then
	echo "Go to https://github.com/rightscale/rsc/blob/master/README.md and install the rsc tool for your OS."
	echo "And, run rsc setup"
	exit 1
fi

echo "Confirm you wan to add the users to account ${ACCOUNT_NUMBER} with all permissions (y/n)"
read resp
if [ ${resp} != "y" ]
then
	echo "EXITING"
	exit 1
fi

cat ${USERS_FILE} |
sed 's/ /~/g' |
sed 's/,/ /g' |
while read firstName lastName companyName emailAddress phoneNumber password
do
	echo "Processing ${emailAddress}"

	# Create the user if not already exists and extract the user href
	firstname=`echo ${firstName} | sed 's/~/ /g'`
    lastname=`echo ${lastName} | sed 's/~/ /g'`
    companyname=`echo ${companyName} | sed 's/~/ /g'`	
	user_href=`rsc --pp --dump=debug -a ${ACCOUNT_NUMBER} cm15 create /api/users "user[first_name]=${firstname}" "user[last_name]=${lastname}" "user[company]=${companyname}" "user[email]=${emailAddress}" "user[phone]=${phoneNumber}" "user[password]=${password}" 2>&1 >/dev/null |
		grep Location | 
		sed 's/  *//g' | 
		cut -d":" -f2`

	# Give the user all permissions - it's a PFT after all
	for role in observer actor server_login admin publisher designer billing server_superuser library security_manager
	do
		# redirect to /dev/null so that duplicate attempt messages are not echoed to the user
		rsc --pp -a ${ACCOUNT_NUMBER} cm15 create /api/permissions "permission[role_title]=${role}" "permission[user_href]=${user_href}" &> /dev/null
	done
done
