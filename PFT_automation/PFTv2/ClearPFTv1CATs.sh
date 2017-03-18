#!/bin/sh
if [ $# -ne 2 ]
then
    echo "Usage: $0 ACCOUNT_LIST_FILE CAT_LIST_FILE"
    exit 1
fi

echo "##########"
echo "THIS SCRIPT DELETES CATS"
echo "Are you sure you want to continue? (y/n)"
echo ""
read reg_answer
if [ ${reg_answer} != "y" ]
then
    echo "Exiting"
    exit 2
 fi

account_list=${1}
cat_list_file=${2}
while read pft_name account_num 
do

  echo "#### Deleting CATs from account ${account_num}"
    
  for i in `cat $cat_list_file`
  do
    cat_filename=${i}
    cat_name=$(sed -n -e "s/^name[[:space:]]['\"]*\(.*\)['\"]/\1/p" $cat_filename)
    echo "Attempting to delete CAT with name ${cat_name}"
    
    catalog_href=$(rsc --pp -r $OAUTH_REFRESH_TOKEN -a $ACCOUNT_ID -h $SHARD_HOSTNAME ss index /api/catalog/catalogs/$ACCOUNT_ID/applications | jq ".[] | select(.name==\"$cat_name\") | .href" | sed 's/"//g')
    if [[ -z "$catalog_href" ]]
    then
      echo "Could NOT find catalog CAT with name ${cat_name}"
    else
      echo "DELETING CAT, ${cat_name} with catalog href: ${catalog_href}"
      rsc -a ${account_num} ss delete ${catalog_href}
    fi

    cat_href=$(rsc -a ${account_num} ss index collections/$ACCOUNT_ID/templates "filter[]=name==$cat_name" | jq -r '.[0].href')
    if [[ -z "$cat_href" ]]
    then
      echo "Could NOT find designer CAT with name ${cat_name}"
    else
      echo "DELETING CAT, ${cat_name} with designer href: ${cat_href}"
      rsc -a ${account_num} ss delete ${cat_href}
    fi
  done
done < ${account_list}