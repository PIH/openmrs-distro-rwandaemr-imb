#!/bin/bash

usage () {
    echo -e "Usage: install.sh [VARIATION] [SERVER]\n"
    echo -e "Installs the configuration FOR VARIATION (butaro or rwinkwavu) to SERVER (the name of an OpenMRS SDK instance at path '~/openmrs/[SERVER]')\n"
    echo -e "Example: ./install.sh rwinkwavu rwinktest\n"
}

if [ $# -eq 0 ]; then
    echo -e "Please provide the distribution variation and name of the server to install to as a command line argument.\n"
    usage
    exit 1
fi

VARIATION=$1
SERVER_ID=$2
SOURCE_DIR=./rwandaemr-imb-${VARIATION}/target/configuration
TARGET_DIR=~/openmrs/$SERVER_ID/configuration

mvn clean install
echo "Removing existing directory at ${TARGET_DIR}"
rm -fR ${TARGET_DIR}
echo "Creating new directory at ${TARGET_DIR}"
mkdir ${TARGET_DIR}
echo "Copying contents of ${SOURCE_DIR} into ${TARGET_DIR}"
cp -a ${SOURCE_DIR}/* ${TARGET_DIR}
echo "Installation complete"