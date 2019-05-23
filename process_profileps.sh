#!/bin/bash

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

# check and create the directory
chkmkdir() {
    local directory_name
    directory_name="$@" 
    if [ ! -d "${directory_name}" ]; then
        mkdir -p "${directory_name}"
    fi
}

# settings for profiles
FILES=src/${SRC}/profiles/*.profile
TGT_DIR=src/${DST}/profiles

# create the directory
chkmkdir ${TGT_DIR}

# cleanup previous processed files
rm -f ${TGT_DIR}/*

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

# cleanup previous processed files
rm -f ${TGT_DIR}/*

# process each profile
for i in ${FILES}; do
    file=$(basename "$i")
    echo Processing ${file}...
    xsltproc process_profileps.xsl "${i}" | \
    awk -f process_objectPermissions.awk > "${TGT_DIR}/${file}"
done