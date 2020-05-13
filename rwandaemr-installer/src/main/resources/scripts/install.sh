#!/bin/bash

## load variables from the vars.txt file
source vars.txt

create_service_user(){
	./create-service-user.sh
}

download_distribution(){
	./download-distribution.sh
}

change_ownership() {
	chown -R ${username}:${username} /opt/${parent_dir}
	chmod 0700 /opt/${parent_dir}
}

if [ "$env_type" == "demo" -o "$env_type" == "prod" -o "$env_type" == "test" ]; then
  mkdir -p /opt/${parent_dir}
  mkdir -p /opt/${parent_dir}/distribution
  create_target_dir
  create_service_user
  download_distribution
  change_ownership
else
  mkdir -p ${parent_dir}
  mkdir -p ${parent_dir}/distribution
  create_target_dir
  download_distribution
fi