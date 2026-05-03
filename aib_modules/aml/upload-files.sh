#!/bin/bash

eval "$(jq -r '@sh "DATASTORE_NAME=\(.DATASTORE_NAME) MACHINE_LEARNING_SERVICE_NAME=\(.MACHINE_LEARNING_SERVICE_NAME) RESOURCE_GROUP_NAME=\(.RESOURCE_GROUP_NAME) STORAGE_ACCOUNT_NAME=\(.STORAGE_ACCOUNT_NAME) MODULE_PATH=\(.MODULE_PATH)  SUBSCRIPTION_ID=\(.SUBSCRIPTION_ID) "')"

if [ -z "$(ls /tmp/ | grep "aml_files_provisioned_${MACHINE_LEARNING_SERVICE_NAME}")" ]; then
    ## Determine the Fileshare name in Azure Storage Account
    FileShareName=$(az ml datastore show --name $DATASTORE_NAME --workspace-name $MACHINE_LEARNING_SERVICE_NAME --resource-group $RESOURCE_GROUP_NAME --subscription $SUBSCRIPTION_ID --query "file_share_name" -otsv)

    ## Create a new directory in the Fileshare called "Scripts" in the Users folder to be shown in the aml UI
    az storage directory create --share-name $FileShareName --name Users/Scripts --account-name $STORAGE_ACCOUNT_NAME --subscription $SUBSCRIPTION_ID &>dircreateout

    ## Upload Scripts to File Shares in the "Scripts" folder
    az storage file upload -s $FileShareName --source $MODULE_PATH/environment-setup.sh --path Users/Scripts/setup.sh --account-name $STORAGE_ACCOUNT_NAME --subscription $SUBSCRIPTION_ID &>fileuploadout
    az storage file upload -s $FileShareName --source $MODULE_PATH/access-check.sh --path Users/Scripts/access-check.sh --account-name $STORAGE_ACCOUNT_NAME --subscription $SUBSCRIPTION_ID &>fileuploadout

    touch "/tmp/aml_files_provisioned_${MACHINE_LEARNING_SERVICE_NAME}_$(date +%Y%m%d_%H%M%S)"
fi
jq -n '{"status": "success"}'
