#!/usr/bin/env bash
#set -x

# Deletes the relevant storage account to store terraform state

RESOURCE_GROUP_NAME="deploy-first-rg"

# Delete Resource Group

az group delete -n $RESOURCE_GROUP_NAME
