#!/bin/bash

#
# usage: process_profileps.sh <source folder> <target folder>
# description: processes(removes everything except objectPerms) all profiles/permsets from <source folder> into the directory <target folder>
#
# process_profile.sh - example script to process profiles/persmission sets from a source folder and output to a target folder
# process_profile.xsl - example xsl script used to filter out elements from a profile/permissionset
# process_objectPermission.awk - example awk script used to determine if an objectPermission should be excluded
# 

# function to check and create a directory
chkmkdir() {
    local directory_name
    directory_name="$1" 
    if [ ! -d "${directory_name}" ]; then
        mkdir -p "${directory_name}"
    fi
}

# check for xsltproc
which xsltproc >/dev/null
if [ $? -eq 1 ]; then
   echo "Please install xsltproc first."
   exit 1
fi

# check for a source and destination
if [ -z "$2" ]; then
    echo "Please specify a source and destination folder. $0 <source> <destination>"
    exit 1
fi

#
SRC=$1
DST=$2

# settings for profiles
FILES=src/${SRC}/profiles/*.profile
TGT_DIR=src/${DST}/profiles

# create the directory
chkmkdir ${TGT_DIR}

# cleanup previous files
rm -rf "${TGT_DIR}/*"

# process each profile
for i in ${FILES}; do
    file=$(basename "$i")
    echo Processing ${file}...
    xsltproc process_profileps.xsl "${i}" | \
    awk -f process_objectPermissions.awk > "${TGT_DIR}/${file}"
done

# settings for permissionsets
FILES=src/${SRC}/permissionsets/*.permissionset
TGT_DIR=src/${DST}/permissionsets

# create the directory
chkmkdir ${TGT_DIR}

# cleanup previous files
rm -rf "${TGT_DIR}/*"

# process each profile
for i in ${FILES}; do
    file=$(basename "$i")
    echo Processing ${file}...
    xsltproc process_profileps.xsl "${i}" | \
    awk -f process_objectPermissions.awk > "${TGT_DIR}/${file}"
done