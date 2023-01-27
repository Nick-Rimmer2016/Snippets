#!/bin/bash

# Set variables for the key vault
keyVaultName="myKeyVault"

# Authenticate to Azure using the Azure CLI
az login

# Get all secrets from the key vault
secrets=$(az keyvault secret list --vault-name $keyVaultName --query [].id --output tsv)

# Loop through the secrets
for secret in $secrets
do
  # Get the secret value
  secretValue=$(az keyvault secret show --id $secret --query value -o tsv)

  # Get the secret name
  secretName=$(echo $secret | awk -F '/' '{print $9}')

  # Output the secret name and value
  echo "Secret name: $secretName"
  echo "Secret Value: $secretValue"
  echo ""
done
