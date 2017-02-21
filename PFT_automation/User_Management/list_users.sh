#!/bin/sh

# Lists users assigned to the given account
# Only shows non-rightscale folks

if [ $# -ne 1 ]
then
    echo "Usage: $0 ACCOUNT_NUM"
    exit
fi

echo "Listing any NON-RIGHTSCALE users assigned to the account."
rsc -a ${1} --pp cm15 index /api/users | jq '.[] | {email: .email}' | 
grep -v "{\|}" |
grep -v -i "rightscale\.com"
