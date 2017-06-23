#!/bin/sh

if [ $# -ne 1 ]
then
	echo "USAGE: $0 BOOSTRAP_ACTION(S)"
	exit 1
fi

bootstrap_action=${1}
PFT_LIST=/Users/mitchellgerdisch/pft_account_management/PFT_all_accounts.txt

echo "Bootstrap actions: ${bootstrap_action}"

for i in PFT_100 PFT_200 PFT_300 PFT_400 PFT_500 PFT_600 PFT_700 PFT_800 PFT_900 PFT_1000 PFT_1100 PFT_1200 PFT_1300 PFT_1400 PFT_1500 PFT_1600 PFT_1700 PFT_1800 PFT_1900 PFT_2000 PFT_2100 PFT_2200 PFT_2300 PFT_2400 DemoAccount
do
	account_num=$(grep "${i} " ${PFT_LIST} | cut -d" " -f2)
	echo "Pushing updates for PFT: ${i}; account number: ${account_num}"
	./EasySetupAccount.sh "${bootstrap_action}" ${account_num}
done

