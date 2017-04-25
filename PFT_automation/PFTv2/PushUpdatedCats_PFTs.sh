#!/bin/sh

for i in PFT_100 PFT_200 PFT_300 PFT_400 PFT_500 PFT_600 PFT_700 PFT_800 PFT_900 PFT_1000 
do
    ./SetupPFTaccount.sh /Users/mitchellgerdisch/git/rs-premium_free_trial/pftv2_bootstrap.sh "cats publish" /Users/mitchellgerdisch/pft_account_management/PFT_all_accounts.txt /Users/mitchellgerdisch/Downloads/nofile.txt ${i}
done


for i in PFT_1100 PFT_1200 PFT_1300 PFT_1400 PFT_1500 PFT_1600 PFT_1700 PFT_1800 PFT_1900 PFT_2000 PFT_2100 PFT_2200 PFT_2300 PFT_2400
do
    ./SetupPFTaccount.sh /Users/mitchellgerdisch/git/rs-premium_free_trial/pftv2_bootstrap.sh "cats publish" /Users/mitchellgerdisch/pft_account_management/PFT_all_accounts.txt /Users/mitchellgerdisch/Downloads/nofile.txt ${i}
done
