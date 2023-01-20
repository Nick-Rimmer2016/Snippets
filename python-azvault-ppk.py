import json
import base64
import requests

# Azure AD Credentials
client_id = '<Your Azure AD Client ID>'
client_secret = '<Your Azure AD Client Secret>'
tenant_id = '<Your Azure AD Tenant ID>'

# Secrets Manager URL
url = 'https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.KeyVault/vaults/<vault-name>/secrets/<secret-name>?api-version=2016-10-01'

# Request headers
headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer <access-token>'}

# Get access token
response = requests.post(f'https://login.microsoftonline.com/{tenant_id}/oauth2/token', data={'grant_type': 'client_credentials', 'client_id': client_id, 'client_secret': client_secret, 'resource': 'https://vault.azure.net'})
access_token = response.json()['access_token']

# Update headers with access token
headers['Authorization'] = f'Bearer {access_token}'

# Send GET request to Secrets Manager
response = requests.get(url, headers=headers)

# Get private key
private_key = response.json()['value']

# Decode private key
private_key = base64.b64decode(private_key)

# Write private key to file
with open('private_key.pem', 'w') as f:
    f.write(private_key.decode())

print("Private key written to 'private_key.pem'.")

import paramiko

# Convert PEM to PPK
pkey = paramiko.RSAKey(filename='private_key.pem')
with open('private_key.ppk', 'w') as f:
    f.write(pkey.to_ppk())

print("Private key written to 'private_key.ppk'.")
