#!/bin/sh

if [ $# -ne 2 ]
then
	echo "USAGE: $0 ACCOUNT_NUMBER firstName lastName companyName emailAddress phoneNumber password"
	echo "Where ACCOUNT_NUMBER is the account number to which to add the users."
	echo "And the user information is the user's"
	echo "   FirstName LastName CompanyName EmailAddress PhoneNumber Password"
	exit 1
fi

ACCOUNT_NUMBER=${1}
firstName=${2} 
lastName=${3} 
companyName=${4} 
emailAddress=${5} 
phoneNumber=${6} 
password=${7}

# Check to see that the rsc tool is installed.
rsc --version > /dev/null
if [ $? -ne 0 ]
then
	echo "Go to https://github.com/rightscale/rsc/blob/master/README.md and install the rsc tool for your OS."
	echo "And, run rsc setup"
	exit 1
fi

user_href=`rsc --pp -a ${ACCOUNT_NUMBER} --xh=Location cm15 create /api/users "user[first_name]=${firstname}" "user[last_name]=${lastname}" "user[company]=${companyname}" "user[email]=${emailAddress}" "user[phone]=${phoneNumber}" "user[password]=${password}"

printf "${user_href}"

