#!/bin/sh
if [ $# -ne 2 ]
then
    echo "Usage: $0 ACCOUNT_NUMBER CAT_LIST_FILE"
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

account_num=${1}
cat_list_file=${2}

  echo "#### Deleting CATs from account ${account_num}"
    
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
