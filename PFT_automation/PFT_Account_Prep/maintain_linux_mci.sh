DEPREACTED FOR A CAT INSTEAD?

#!/bin/sh

# Creates/updates the base linux MCI used for PFT assets
# 
# MCI Name: PFT Base Linux
# Tags: Install-at-boot tags
# Images: 
#   AWS - same as the current RL10 base linux MCI
#   ARM - same as the current RL10 base linux MCI
#   VMware - there should already be a VMware image named "PFT_Ubuntu_vmware" in the VMware environment(s). If not create one. See PFTv2 Wookiee for the Admin guide.
#   Google - Find the latest Ubuntu image and use that one. Do NOT trust the current RL10 base linux MCI for the link since Google deprecates the images early and often.

# SCRIPT PREREQUISITES: Assumes you have done "rsc setup" and that you have the necessary access permissions to the account.

if [ $# -ne 1 ]
then
    echo "Usage: $0 <ACCOUNT_NUMBER>"
    echo "Where <ACCOUNT_NUMBER> is the RightScale account number being worked on."
    exit 1
fi

ACCOUNT_NUMBER=${1}

# Check if the MCI already exists
rsc -a ${ACCOUNT_NUMBER} cm15 index /api/multi_cloud_images "filter[]=name==PFT Base Linux" | grep "name" > /dev/null

if [ $? -ne 0 ]
then
   echo "MCI not found"
   # so create it
   rsc 
fi


