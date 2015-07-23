# This set of scripts are used to setup and test and clean up the PFT accounts.

Account Catalog Setup and Test:
- multi_setup_pft_catalog.sh: This script sets up the "Business Hours" schedule and uploads and publishes the cats in the provided list.
- multi_test_envs.sh: This script launches the basic Linux app in both AWS and VMware as a basic test in the accounts provided.
- multi_list_cloudapps.sh: This script will show all the apps in all the given accounts and identify the running and failed ones.

Account Cleanup:
- multi_terminate_apps.sh: Termintes ALL running and failed cloud apps in the accounts provided.
- multi_delete_apps.sh: Deletes ALL terminated cloud apps in the accounts provided. Run after the previous command has completed.
