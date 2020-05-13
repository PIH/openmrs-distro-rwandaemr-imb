#!/bin/bash

## load variables from the vars.txt file
source vars.txt

create_target_dir(){
    if [ "$env_type" == "demo" -o "$env_type" == "prod" -o "$env_type" == "test" ]; then
      mkdir -p /opt/${parent_dir}/distribution
    else
      mkdir -p ${parent_dir}
      mkdir -p ${parent_dir}/distribution
    fi
}

create-service-user(){
	./create-service-user.sh ${parent_dir}
}

download_distribution(){
if [ "$env_type" == "demo" -o "$env_type" == "prod" -o "$env_type" == "test" ]; then
	./download-distribution.sh
else
  ./download-distribution.sh
fi
}

change_ownership() {
if [ "$env_type" == "demo" -o "$env_type" == "prod" -o "$env_type" == "test" ]; then
	chown -R ${username}:${username} /opt/${parent_dir}
	chmod 0700 /opt/${parent_dir}
else
  echo " "
fi
}

create_target_dir
create-service-user
download_distribution
change_ownership