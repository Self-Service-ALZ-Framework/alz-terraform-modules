#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

eval "$(jq -r '@sh "subscription_id=\(.subscription_id) location=\(.location) rg=\(.rg)"')"

az cognitiveservices account create --kind TextAnalytics --location $location --name termsacceptresource-$rg --resource-group $rg --sku S0 --subscription $subscription_id --yes

sleep 10

az cognitiveservices account delete --name termsacceptresource-$rg -g $rg --subscription $subscription_id