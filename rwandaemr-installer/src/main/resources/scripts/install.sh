#!/bin/bash

## load variables from the vars.txt file
source vars.txt

create_target_dir(){
    if [ "$env_type" == "demo" -o "$env_type" == "prod" -o "$env_type" == "test" ]; then
      mkdir -p /opt/${parent_dir}
      mkdir -p /opt/${parent_dir}/distribution
    else
      mkdir -p ${parent_dir}
      mkdir -p /opt/${parent_dir}/distribution
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

unzip_distribution(){
	unzip *.zip
	cd $(pwd)
}


create_target_dir
create-service-user
download_distribution
  #cd ${parent_dir}
  #unzip_distribution