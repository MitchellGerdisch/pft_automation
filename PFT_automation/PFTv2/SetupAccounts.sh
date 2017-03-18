# This runs the bootstrap script colocated with the PFT account for each account.

function usage ()
{
    echo "Usage: $0 ACCOUNT_INFO BOOTSTRAP_SCRIPT BOOTSTRAP_PARAMETER SHARD_HOSTNAME OAUTH_REFRESH_TOKEN"
    echo "Where ACCOUNT_INFO is a file containing space-separated list of: PFT Account Name, RightScale Account Number"
    echo "Where BOOTSTRAP_SCRIPT is the path to the pftv2_bootstrap.sh script."
    echo "Where BOOTSTRAP_PARAMETER is the argument for the bootstrap function. See the bootstrap function for details."
    echo "Where SHARD_HOSTNAME is us-3.rightscale.com or us-4.rightscale.com depending on the accounts and refresh token being used."
    echo "Where OAUTH_REFRESH_TOKEN is the service account REFRESH TOKEN to set up across the accounts."
    echo "   NOTE: There is a PFT-specific service account user whose token you should use for PFT setup."
}

if [ $# -ne 5 ]
then
    usage
    exit 1
fi
 
ACCOUNT_INFO="${1}"
BOOTSTRAP_SCRIPT="${2}"
BOOTSTRAP_PARAMETER="${3}"

export SHARD_HOSTNAME="${4}"
export OAUTH_REFRESH_TOKEN="${5}"

BOOTSTRAP_SCRIPT_DIR=$(dirname "${BOOTSTRAP_SCRIPT}")
cd ${BOOTSTRAP_SCRIPT_DIR}

while read pft_name account_num 
do
	
	echo "Bootstrapping Account: ${pft_name}/${account_num}"
	
	export ACCOUNT_ID=${account_num}
	
	${BOOTSTRAP_SCRIPT} ${BOOTSTRAP_PARAMETER}
	
	echo ""
	echo "##############################"
	echo ""

done < ${ACCOUNT_INFO}
