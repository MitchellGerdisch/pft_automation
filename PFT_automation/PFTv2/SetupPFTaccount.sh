# Run bootstrap for specified PFT account
# Then run clean up script that removes deprecated PFT items.
# Assumes rsc setup has been run with credentials that have access to the account.


function usage ()
{
    echo "Usage: $0 BOOTSTRAP_SCRIPT BOOTSTRAP_ACTION PFT_LIST DEPRECATED_CAT_LIST PFT_NAME"
    echo "Where BOOTSTRAP_SCRIPT is the path to the bootstrap script"
    echo "Where BOOTSTRAP_ACTION is the action parameter the bootstrap script takes."
    echo "Where DEPRECATED_CAT_LIST is a file containing the paths to the deprecated CATs. Pass non-existent file to skip."
    echo "Where PFT_LIST is a file containing the PFT names and account numbers. (e.g. PFT_100 123456)"
    echo "Where PFT_NAME is "PFT_100", etc."
}

if [ $# -ne 5 ]
then
    usage
    exit 1
fi

BOOTSTRAP_SCRIPT=${1}
BOOTSTRAP_PARAMETER=${2}
PFT_LIST=${3}
DEPRECATED_CAT_LIST=${4}
PFT_NAME=${5}

# find the account number
account_num=$(grep "${PFT_NAME} " ${PFT_LIST} | cut -d" " -f2)

echo "#################################"
echo "Setting up ${PFT_NAME} with account number ${account_num}"
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

${BOOTSTRAP_SCRIPT} ${BOOTSTRAP_PARAMETER}

echo ""
echo "##############################"
echo ""


if [ -f $DEPRECATED_CAT_LIST ]
then

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
 fi
  
 echo "#### COMPLETED $PFT_NAME #######"
