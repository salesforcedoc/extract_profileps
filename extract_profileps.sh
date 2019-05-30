#!/bin/bash

#
# usage: extract_profileps.sh <sfdx_org_alias>
# description: extracts all profiles/permsets from <sfdx_org_alias> and outputs to a folder named 'src/<sfdc_org_alias>'
#
# extract_profile.sh - example script to extract profiles and persmission sets from an org
# extract_profile.awk - example awk script used to generate the package.xml
#
# this script requires you to connect the sfdx cli to an org.  see below for examples:
#
# sfdx force:auth:web:login -r https://test.salesforce.com -a <sfdx_org_alias>
# sfdx force:auth:web:login -r https://login.salesforce.com -a <sfdx_org_alias>
# 

# function to check and create a directory
chkmkdir() {
    local directory_name
    directory_name="$1" 
    if [ ! -d "${directory_name}" ]; then
        mkdir -p "${directory_name}"
    fi
}

# check for sfdx first
which sfdx >/dev/null
if [ $? -eq 1 ]; then
   echo "Please install sfdx first."
   exit 1
fi

# check for an sfdx org alias
if [ -z "$1" ]; then
    echo "Please specify an sfdx org alias. $0 <sfdx_org_alias>"
    exit 1
fi

# 
SFDX_ORG_ALIAS=$1
TGT_DIR=./src/${SFDX_ORG_ALIAS}
TMP_DIR=./tmp/${SFDX_ORG_ALIAS}

# create the target directory
chkmkdir ${TGT_DIR}/profiles
chkmkdir ${TGT_DIR}/permissionsets
chkmkdir ${TMP_DIR}

# cleanup previous files
rm -rf "${TGT_DIR}/profiles/*"
rm -rf "${TGT_DIR}/permissionsets/*"
rm -rf "${TMP_DIR}/*"

# generate a list of sobjects and create the package.xml
echo Creating sobject/profile/permsets package.xml...
sfdx force:schema:sobject:list -u ${SFDX_ORG_ALIAS} -c all | sort | awk -f extract_profileps.awk > ${TMP_DIR}/package.xml

# retrieve the metadata for these objects
echo Retrieving sobject/profile/permsets metadata...
sfdx force:mdapi:retrieve -u ${SFDX_ORG_ALIAS} -r ${TMP_DIR} -k ${TMP_DIR}/package.xml -w -1 > /dev/null 2>&1

# extract the contents
if [ -f "${TMP_DIR}/unpackaged.zip" ]; then

    # unzip package
    echo Unzipping sobject/profile/permsets metadata...
    unzip -q -o -a -d ${TMP_DIR} ${TMP_DIR}/unpackaged.zip
 
    # copy metadata files
    echo Transferring sobject/profile/permsets metadata...
    cp -r ${TMP_DIR}/unpackaged/profiles/* "${TGT_DIR}/profiles/"
    cp -r ${TMP_DIR}/unpackaged/permissionsets/* "${TGT_DIR}/permissionsets/"
    cp -r ${TMP_DIR}/unpackaged/package.xml "${TGT_DIR}"
    echo \* | awk -f extract_profileps.awk > ${TGT_DIR}/package.xml

    # cleanup - uncomment the below if you want to have it cleanup the temp directory
    #echo Cleaning up...
    #rm -rf "${TMP_DIR}/*"

fi