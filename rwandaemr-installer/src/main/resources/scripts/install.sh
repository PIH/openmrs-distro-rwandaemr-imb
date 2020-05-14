#!/bin/bash

## load variables from the env file
source vars

create_base_dir(){
  mkdir -p ${BASE_DIR}
}

download_maven_distribution(){
    ARTIFACT_ID=${ARTIFACT_ID1}
    CLASSIFIER=${CLASSIFIER1}
    TARGET_DIR=${BASE_DIR}/${CLASSIFIER}
    create_base_dir
    mkdir -p ${TARGET_DIR}
	  ./download-maven-artifacts ${ARTIFACT_ID} ${VERSION} ${TARGET_DIR} ${CLASSIFIER}
	  mv $(pwd)/$TARGET_DIR/${ARTIFACT_ID1}-${VERSION}/* $TARGET_DIR
	  rm -rf $(pwd)/$TARGET_DIR/${ARTIFACT_ID1}-${VERSION}
}

download_maven_installer(){
	  CLASSIFIER=${CLASSIFIER2}
	  TARGET_DIR=${BASE_DIR}/${CLASSIFIER}
	  create_base_dir
	  mkdir -p ${TARGET_DIR}
	  ./download-maven-artifacts ${ARTIFACT_ID2} ${INSTALLER_VERSION} ${TARGET_DIR} ${CLASSIFIER}
	  mv $(pwd)/$TARGET_DIR/${ARTIFACT_ID2}-${INSTALLER_VERSION}/* $TARGET_DIR
	  rm -rf $(pwd)/$TARGET_DIR/${ARTIFACT_ID2}-${INSTALLER_VERSION}
}

download_maven_distribution
download_maven_installer
