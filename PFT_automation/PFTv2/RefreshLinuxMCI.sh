# Run bootstrap for specified PFT account
# Then run clean up script that removes deprecated PFT items.
# Assumes rsc setup has been run with credentials that have access to the account.


function usage ()
{
    echo "Usage: $0 PFT_LIST" 
    echo "Where PFT_LIST is a file containing the PFT names and account numbers. (e.g. PFT_100 123456)"
}

if [ $# -ne 1 ]
then
    usage
    exit 1
fi

BOOTSTRAP_SCRIPT=$HOME/git/rs-premium_free_trial/pftv2_bootstrap.sh 
BOOTSTRAP_PARAMETER="management_mcis_only"
PFT_LIST=${1}

while read pft_name account_num
do

	echo "#################################"
	echo "Updating MCIs for ${pft_name}"
	echo "#################################"

	RSC="rsc -a ${account_num}"

	# Get the shard for the account
	shard=$(${RSC} cm15 show /api/accounts/${account_num} | jq '.links[] | select(.rel=="cluster") | .href' | sed 's/\"//g' | cut -d"/" -f4)
	export SHARD_HOSTNAME="us-${shard}.rightscale.com"

	# Grab the PFT_RS_REFRESH_TOKEN to use for the bootstrap call.
	oauth_token=$(${RSC} cm15 index /api/credentials "filter[]=name==PFT_RS_REFRESH_TOKEN" "view=sensitive" | jq '.[0].value' | sed 's/\"//g')
	export OAUTH_REFRESH_TOKEN="${oauth_token}"

	export ACCOUNT_ID=${account_num}

	BOOTSTRAP_SCRIPT_DIR=$(dirname "${BOOTSTRAP_SCRIPT}")
	cd ${BOOTSTRAP_SCRIPT_DIR}


	${BOOTSTRAP_SCRIPT} ${BOOTSTRAP_PARAMETER}

	echo ""
	echo "##############################"
	echo ""

done < ${PFT_LIST}

