
#-------------------------------------------------------------------------------------------------------
# AZCOPY SCRIPT - ON PREM OR VM/CONTAINER COPY TO AZURE BLOB (Authentication Azure - Service Principal)
#-------------------------------------------------------------------------------------------------------
# PRE-REQUISITES : 
# Download and Install Azure CLI (https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest&tabs=azure-cli)
# Download and Install PowerShell 7+ (https://github.com/PowerShell/PowerShell/releases)
# Powershell run [Install_Module Az]
# Powershell run [Import_Module Az]
# Download AZCopy (https://github.com/Azure/azure-storage-azcopy)
# REFERENCES: 
# https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal
# https://docs.microsoft.com/en-us/azure/storage/common/storage-sas-overview
# https://docs.microsoft.com/en-us/azure/storage/common/storage-ref-azcopy-copy
# AUTHOR : Brian Brewer (Observian Inc.) 07-28-2020
#-------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------
# OBFUSCATION SERVICE PRINCIPLE KEY
#----------------------------------------------------------------------------------------------------
# $servicePrincipalKey = ConvertTo-SecureString "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" -AsPlainText -Force
#
# *** ON PREMISE KEY FILE ***
# Run this another Powershell to create the Password Encrypted File (only works on current machine + current user)
# (get-credential).password | ConvertFrom-SecureString | set-content "C:\[AzCopyFolder]\password.txt"
# *** KEY VAULT ***
# (Get-AzKeyVaultSecret -vaultName "Contoso-Vault2" -name "ExamplePassword").SecretValueText
# *** CERTIFICATE AUTHENTICATION W KEY VAULT ***
# https://docs.microsoft.com/en-us/powershell/module/az.keyvault/get-azkeyvaultcertificate?view=azps-4.4.0
# https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_certificate.html
#-----------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------
# CONNECT TO AZURE USING SERVICE PRINCIPLE
#-------------------------------------------------------------------------------------------------------
$azureAplicationId ="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxx"
$azureTenantId= "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxx"
$servicePrincipalKey = Get-Content "C:\[AzCopyFolder]\password.txt" | ConvertTo-SecureString
$psCred = New-Object System.Management.Automation.PSCredential($azureAplicationId , $servicePrincipalKey)
Connect-AzAccount -Credential $psCred -Tenant $azureTenantId -ServicePrincipal

# Change subscription if required.
az account set --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxx
#-----------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------
# AZCOPY COMMANDS
#-------------------------------------------------------------------------------------------------------

.\AzCopy\azcopy copy c:\AzCopy\testfile.gz "https://{storageAccount}.blob.core.windows.net/{container}/{folder}/{filename}.gz?{storageblobSASUrl}"

#-------------------------------------------------------------------------------------------------------
# OUTPUT
#-------------------------------------------------------------------------------------------------------
# PowerShell 7.0.1
# Copyright (c) Microsoft Corporation. All rights reserved.
#
# https://aka.ms/powershell
# Type 'help' to get help.
#
#   A new PowerShell stable release is available: v7.0.3
#   Upgrade now, or check out the release page at:
#     https://aka.ms/PowerShell-Release?tag=v7.0.3
# 
# PS C:\Users\xxx> $azureAplicationId ="XXXXXXXx-XXXXXX-XXX-XXXX-XXXXXXXXXXXX"
# PS C:\Users\xxx> $azureTenantId= "XXXXXXX-XXXX-XXX-XXXX-XXXXXXXXXX"
# PS C:\Users\xxx> $servicePrincipalKey = Get-Content "{C:\AzCopyfolder}\password.txt" | ConvertTo-SecureString
# PS C:\Users\xxx> $psCred = New-Object System.Management.Automation.PSCredential($azureAplicationId , $servicePrincipalKey)
# PS C:\Users\xxx> Connect-AzAccount -Credential $psCred -Tenant $azureTenantId -ServicePrincipal
# WARNING: The provided service principal secret will be included in the 'AzureRmContext.json' file found in the user profile ( C:\Users\[xxx]\.Azure ). Please ensure that this director
# y has appropriate protections.
# 
# Account                              SubscriptionName     TenantId                             Environment
# -------                              ----------------     --------                             -----------
# XXXXXXX-XXXX-XXX-XXXX-XXXXXXXXXX Azure subscription 1 XXXXXXX-XXXX-XXX-XXXX-XXXXXXXXXX AzureCloud
