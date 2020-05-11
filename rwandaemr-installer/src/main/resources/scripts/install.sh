#!/bin/bash

distribution="$1"
version="$2"
targetDir="$3"

create_target_dir(){
	mkdir -p ${targetDir}
	mkdir -p ${targetDir}/distribution
}

create-service-user(){
	./create-service-user.sh ${targetDir}
}

download_distribution(){
	./download-distribution.sh ${distribution} ${version} ${targetDir}/distribution/
}

unzip_distribution(){
	cd $(pwd)/${targetDir}/distribution
	unzip *.zip
	cd $(pwd)
}

create_target_dir
#create-service-user
download_distribution
unzip_distribution
