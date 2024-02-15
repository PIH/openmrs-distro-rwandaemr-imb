#!/bin/bash

usage () {
    echo -e "Usage: install.sh [VARIATION] [SERVER]\n"
    echo -e "Installs the VARIATION (butaro or rwinkwavu) to a SERVER (the name of an OpenMRS SDK instance at path '~/openmrs/[SERVER]')\n"
    echo -e "Example: ./install.sh rwinkwavu rwinktest\n"
}

if [ $# -eq 0 ]; then
    echo -e "Please provide the distribution variation and name of the server to install to as a command line argument.\n"
    usage
    exit 1
fi

VARIATION=$1
SERVER_ID=$2
PROJECT_DIR=rwandaemr-imb-${VARIATION}
DISTRO_PROPERTIES_FILE=${PROJECT_DIR}/target/distro/web/openmrs-distro.properties
SOURCE_CONFIG_DIR=${PROJECT_DIR}/target/configuration
TARGET_CONFIG_DIR=~/openmrs/$SERVER_ID/configuration
SOURCE_FRONTEND_DIR=${PROJECT_DIR}/target/dist
TARGET_FRONTEND_DIR=~/openmrs/$SERVER_ID/frontend

echo "Building the project at ${PROJECT_DIR}"
mvn clean install -f ${PROJECT_DIR}/pom.xml

echo "Deploying the project at ${DISTRO_PROPERTIES_FILE} to ${SERVER_ID}"
mvn openmrs-sdk:deploy -Ddistro=${DISTRO_PROPERTIES_FILE} -DserverId=${SERVER_ID}

echo "Removing existing configuration directory at ${TARGET_CONFIG_DIR}"
rm -r ${TARGET_CONFIG_DIR}
echo "Creating new configuration directory at ${TARGET_CONFIG_DIR}"
mkdir ${TARGET_CONFIG_DIR}
echo "Copying contents of ${SOURCE_CONFIG_DIR} into ${TARGET_CONFIG_DIR}"
cp -a ${SOURCE_CONFIG_DIR}/* ${TARGET_CONFIG_DIR}

echo "Removing existing frontend directory at ${TARGET_FRONTEND_DIR}"
rm -r ${TARGET_FRONTEND_DIR}
echo "Creating new frontend directory at ${TARGET_FRONTEND_DIR}"
mkdir ${TARGET_FRONTEND_DIR}
echo "Copying contents of ${SOURCE_FRONTEND_DIR} into ${TARGET_FRONTEND_DIR}"
cp -a ${SOURCE_FRONTEND_DIR}/* ${TARGET_FRONTEND_DIR}
echo "Linking configuration from configuration frontend into frontend site directory"
ln -s ${TARGET_CONFIG_DIR}/frontend ${TARGET_FRONTEND_DIR}/site

echo "Installation complete"