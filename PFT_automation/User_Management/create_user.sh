#!/bin/sh

if [ $# -ne 6 ]
then
	#echo "USAGE: $0 ACCOUNT_NUMBER firstName lastName companyName emailAddress phoneNumber password"
	echo "USAGE: $0 firstName lastName companyName emailAddress phoneNumber password"
	echo "Where ACCOUNT_NUMBER is the account number to which to add the users."
	echo "And the user information is the user's"
	echo "   FirstName LastName CompanyName EmailAddress PhoneNumber Password"
	exit 1
fi

#ACCOUNT_NUMBER=${1}
FirstName=${1} 
LastName=${2} 
CompanyName=${3} 
EmailAddress=${4} 
PhoneNumber=${5} 
Password=${6}

# Check to see that the rsc tool is installed.
rsc --version > /dev/null
if [ $? -ne 0 ]
then
	echo "Go to https://github.com/rightscale/rsc/blob/master/README.md and install the rsc tool for your OS."
	echo "And, run rsc setup"
	exit 1
fi

#user_href=`rsc --pp -a ${ACCOUNT_NUMBER} --xh=Location cm15 create /api/users "user[first_name]=${FirstName}" "user[last_name]=${LastName}" "user[company]=${CompanyName}" "user[email]=${EmailAddress}" "user[phone]=${PhoneNumber}" "user[password]=${Password}"`
user_href=`rsc --pp --xh=Location cm15 create /api/users "user[first_name]=${FirstName}" "user[last_name]=${LastName}" "user[company]=${CompanyName}" "user[email]=${EmailAddress}" "user[phone]=${PhoneNumber}" "user[password]=${Password}"`

printf "${user_href}"

