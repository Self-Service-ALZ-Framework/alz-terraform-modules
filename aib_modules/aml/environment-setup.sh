#!/bin/bash

set -e
echo "-----------------------------------------Injecting environment variables to the user------------------------------------------------------------"
echo "export DEFAULT_IDENTITY_CLIENT_ID=$DEFAULT_IDENTITY_CLIENT_ID" >>/etc/environment
echo "export MSI_SECRET=$MSI_SECRET" >>/etc/environment
echo "export MSI_ENDPOINT=$MSI_ENDPOINT" >>/etc/environment

echo "-----------------------------------------------------Setting up gcp python registry-------------------------------------------------------------"
echo """[distutils]
index-servers =
    quickstart-python-repo

[quickstart-python-repo]
repository: https://europe-west1-python.pkg.dev/vf-grp-aib-prd-mirror/pypi-repository/""" >/etc/.pypirc

echo """[global]
index-url = https://europe-west1-python.pkg.dev/vf-grp-aib-prd-mirror/pypi-repository/simple/""" >/etc/pip.conf

sudo -u azureuser -i <<'EOF'
echo $DEFAULT_IDENTITY_CLIENT_ID
echo "------------------------------------------------Installing gcloud-------------------------------------------------------------------------------"
sudo snap install google-cloud-cli --classic
echo "--------------------------------------------------Creating gcloud credentials file---------------------------------------------------------------"
gcloud iam workload-identity-pools create-cred-config \
    projects/181294520557/locations/global/workloadIdentityPools/azure-pool/providers/entraid \
    --service-account=azure-access@vf-grp-aib-prd-mirror.iam.gserviceaccount.com \
    --credential-source-url="$MSI_ENDPOINT?resource=https://management.azure.com&api-version=2017-09-01&clientid=$DEFAULT_IDENTITY_CLIENT_ID" \
    --credential-source-headers=Secret=$MSI_SECRET --credential-source-type=json --credential-source-field-name=access_token \
    --output-file=/home/azureuser/cred-file.json
echo "-----------------------------------------Authenticating gcloud with credentials------------------------------------------------------------------"
gcloud auth login --cred-file=/home/azureuser/cred-file.json --log-http
pip install --timeout=1000 --index-url https://ca-vf-aib-conn-hub.agreeableflower-621730a1.westeurope.azurecontainerapps.io keyring keyrings.google-artifactregistry-auth
echo "export GOOGLE_APPLICATION_CREDENTIALS='/home/azureuser/cred-file.json'" | tee -a $HOME/.profile >/dev/null
EOF
