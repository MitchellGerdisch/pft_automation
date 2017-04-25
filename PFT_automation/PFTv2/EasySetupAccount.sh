# Run bootstrap for specified customer account
# Makes some assumptions about where the bootstrap script is found, and that the PFT_RS_REFRESH_TOKEN has been
# set up so it it can use it for hitting the API.


function usage ()
{
    echo "Usage: $0 BOOTSTRAP_ACTION ACCOUNT_NUMBER"
    echo "Where BOOTSTRAP_ACTION is the bootstrap script parameter"
    echo "Where ACCOUNT_NUMBER is the RightScale Account Number"
}

if [ $# -ne 2 ]
then
    usage
    exit 1
fi

BOOTSTRAP_SCRIPT="$HOME/git/rs-premium_free_trial/pftv2_bootstrap.sh"
BOOTSTRAP_PARAMETER=${1}
account_num=${2}

echo "#################################"
echo "Setting up account number ${account_num}"
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

echo "Bootstrapping Account: ${PFT_NAME}/${account_num}"

echo "-------"
echo "Continue? (y/n)"
read resp
if [ ${resp} != "y" ]
then
    echo "Exiting ...."
    exit 2
 fi

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
  
  
 echo "#### COMPLETED $PFT_NAME #######"
