# This runs the bootstrap script colocated with the PFT account for each account.

function usage ()
{
    echo "Usage: $0 ACCOUNT_INFO BOOTSTRAP_SCRIPT BOOTSTRAP_PARAMETER SHARD_HOSTNAME OAUTH_REFRESH_TOKEN DEPRECATED_CAT_LIST"
    echo "Where ACCOUNT_INFO is a file containing space-separated list of: PFT Account Name, RightScale Account Number"
    echo "Where BOOTSTRAP_SCRIPT is the path to the pftv2_bootstrap.sh script."
    echo "Where BOOTSTRAP_PARAMETER is the argument for the bootstrap function. See the bootstrap function for details."
    echo "Where SHARD_HOSTNAME is us-3.rightscale.com or us-4.rightscale.com depending on the accounts and refresh token being used."
    echo "Where OAUTH_REFRESH_TOKEN is the service account REFRESH TOKEN to set up across the accounts."
    echo "Where DEPRECATED_CAT_LIST is a list of CAT files that should be removed from the account."
    echo "   NOTE: There is a PFT-specific service account user whose token you should use for PFT setup."
}

if [ $# -ne 6 ]
then
    usage
    exit 1
fi
 
ACCOUNT_INFO="${1}"
BOOTSTRAP_SCRIPT="${2}"
BOOTSTRAP_PARAMETER="${3}"

export SHARD_HOSTNAME="${4}"
export OAUTH_REFRESH_TOKEN="${5}"
DEPRECATED_CAT_LIST="${6}"

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
	
	echo "Removing deprecated CATs"

    cat_list_file=${DEPRECATED_CAT_LIST}

  for i in `cat $cat_list_file`
  do
    cat_filename=${i}
    cat_name=$(sed -n -e "s/^name[[:space:]]['\"]*\(.*\)['\"]/\1/p" $cat_filename)
    echo "Attempting to delete CAT with name ${cat_name}"
    
    catalog_href=$(rsc --pp -a $account_num ss index /api/catalog/catalogs/$account_num/applications | jq ".[] | select(.name==\"$cat_name\") | .href" | sed 's/"//g')
    if [[ -z "$catalog_href" ]]
    then
      echo "Could NOT find catalog item with name: \"${cat_name}\""
    else
      echo "DELETING catalog item, \"${cat_name}\" with catalog href: ${catalog_href}"
      rsc -a ${account_num} ss delete ${catalog_href}
    fi

    cat_href=$(rsc -a ${account_num} ss index collections/$account_num/templates "filter[]=name==$cat_name" | jq -r '.[0].href')
    if [[ -z "$cat_href" ]]
    then
      echo "Could NOT find uploaded CAT with name \"${cat_name}\""
    else
      echo "DELETING CAT, \"${cat_name}\" with designer href: ${cat_href}"
      rsc -a ${account_num} ss delete ${cat_href}
    fi
  done
  
  # record the SS catalog for each PFT to check later
  rsc -a ${account_num} --pp --xm '.template_info .name' ss index catalog/catalogs/${ACCOUNT_NUM}/applications | sort > $HOME/Downloads/${pft_name}_SScatalog.txt

done < ${ACCOUNT_INFO}
