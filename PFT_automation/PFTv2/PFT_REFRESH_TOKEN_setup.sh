# PFT accounts need a PFT_REFRESH_TOKEN for the LAMP CAT.
# This script sets that up across the provided accounts using the provided refresh tokens (one for us-3 and one for us-4).
# The conceit here is that one can use a single refresh token across all the PFT accounts in a given shard.
# Unfortunately one of the PFT accounts is us-4 and so needs it's own token.

function usage ()
{
    echo "Usage: $0 ACCOUNT_INFO RS_HOST_NAME OAUTH_REFRESH_TOKEN"
    echo "Where ACCOUNT_INFO is a file containing space-separated list of: PFT Account Name, RightScale Account Number"
    echo "Where RS_HOST_NAME is us-3.rightscale.com or us-4.rightscale.com depending on the accounts and refresh token being used."
    echo "Where OAUTH_REFRESH_TOKEN is the service account REFRESH TOKEN to set up across the accounts."
    echo "   NOTE: There is a service account user named "PFT_Service_Account" in PFT_700 that can be used as the source for this token."
}

if [ $# -ne 3 ]
then
    usage
    exit 1
fi
 
ACCOUNT_INFO="${1}"
RS_HOST_NAME="${2}"
OAUTH_REFRESH_TOKEN="${3}"

while read pft_name account_num 
do
	
	echo "Processing Account: ${pft_name}/${account_num}"

	# Create PFT_REFRESH_TOKEN Credential in the account with the given OAUTH token.	
	rsc -a ${account_num} -h ${RS_HOST_NAME} -r ${OAUTH_REFRESH_TOKEN} cm15 create /api/credentials "credential[name]=PFT_RS_REFRESH_TOKEN" "credential[description]=Used by PFT CATs" "credential[value]=$OAUTH_REFRESH_TOKEN"


done < ${ACCOUNT_INFO}
