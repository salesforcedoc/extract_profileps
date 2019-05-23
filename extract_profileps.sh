#!/bin/bash

# check for sfdx first
which sfdx >/dev/null
if [ $? -eq 1 ]; then
   echo "Please install sfdx first."
   exit 1
fi

# connect sfdx cli to an org and use the alias here
# use sfdx force:auth:web:login -r https://test.salesforce.com -a <alias>
# check for an org_alias
if [ -z "$1" ]; then
    echo "Please specify an alias. $0 <org_alias>"
    exit 1
fi

# 
SFDX_ORG_ALIAS=$1
TGT_DIR=./src/${SFDX_ORG_ALIAS}
TMP_DIR=./tmp/${SFDX_ORG_ALIAS}

# check and create the directory
chkmkdir() {
    local directory_name
    directory_name="$@" 
    if [ ! -d "${directory_name}" ]; then
        mkdir -p "${directory_name}"
    fi
}

# create the target directory
chkmkdir ${TGT_DIR}/profiles
chkmkdir ${TGT_DIR}/permissionsets 
chkmkdir ${TMP_DIR}

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

    # cleanup
    #echo Cleaning up...
    #rm -rf "${TMP_DIR}/*"

fi
