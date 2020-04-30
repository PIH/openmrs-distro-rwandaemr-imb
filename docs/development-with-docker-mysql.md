### Developing using Dockerized MySQL

Using Docker for MySQL, particularly for development and testing, has a lot of benefits.  
The biggest benefit is that you can set things up such that everyone does not need to independently source starter 
databases in when working on  systems where these can be quite large and time-consuming.   
Other benefits include easily enabling switching between various databases for different uses, 
or deploying different databases for testing migrations, running performance tests, or a starting with a 
known set of curated test data for automated regression testing.  
This page aims to document some of the most common operations as a reference guide for those who wish to do this.

For all of these examples, we will name our container “mysql-rwanda”, and walk through various scenarios assuming 
setting up a Rwanda-based development or test system.  The exact same process applies regardless of country or distribution.

#### Create a new MySQL container (and run it)

```
docker run --name mysql-rwanda -d -p 3308:3306 -e MYSQL_ROOT_PASSWORD=root \
           -v /host-location-1:/share \
           -v /host-location-2:/container/location/of/choice \
            mysql:5.6 --character-set-server=utf8 --collation-server=utf8_unicode_ci --max_allowed_packet=1G
```

The above does the following:
* Names the container “mysql-rwanda” - change to whatever you want to call this on your system
* Exposes the standard MySQL port 3306 on your machine as port 3308 - change to whatever you want
* Sets the root password to “root” - change as appropriate
* Mounts a volume into the container at ```/share``` that is available on your host machine at ```/host-location-1```
  - This is not strictly required, but useful to share between host and container, especially SQL scripts and exports
* Mounts the container's mysql data directory onto your host machine at ```/host-location-2```
  - This is not strictly required, but very useful if you have an archived MySQL data directory available to mount in
* Runs MySQL version 5.6
* Sets configuration properties - character set, collation, max allowed packet - you can adjust as needed.
* More documentation of all of this and more is here:  https://hub.docker.com/_/mysql

#### Access your new MySQL container from a bash shell, and run standard MySQL commands

```
$ docker exec -it mysql-rwanda bash
root@46ac368b4cfe:/#
```
For those used to working with VMs, this is sort of like the equivalent of “ssh”-ing into the machine.  
Once in, you can run mysql commands just like if it was running locally:

```
root@46ac368b4cfe:/# mysql -uroot -proot
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.6.46 MySQL Community Server (GPL)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

From here, you can query tables, source SQL backups into your DB, etc.

For example, if you had a SQL Dump backup file located on your host at:  
/host/location/of/choice/openmrs-backup.sql and you wanted to source this into a new DB in your container, 
you’d run the following.  

```
mysql> create database openmrs default charset utf8;
mysql> source /container/location/of/choice/openmrs-backup.sql
```

Note that we need to refer to the location in the container, not the location on the host:

#### Access your container

This will work exactly like a native MySQL installation.  You would connect to localhost.  The only difference
is that if you chose a different port to expose on your host machine (eg. 3308), then you would choose this port 
in your connection_url.

You should be able to connect from a local OpenMRS instance including the SDK, or from any SQL client that connects with
JDBC/ODBC by specifying the appropriate server url, username, and password.

#### Stop your container:

```docker stop mysql-rwanda```

This stops the container but does not delete any state or data.  
You can start it back up again from where you left off with the docker start command below

#### Start your container back up again

```docker start mysql-rwanda```

This starts an existing container back up if you had previously stopped it (or it had stopped due to a computer restart, etc)

#### View the logs

```docker logs mysql-rwink```

#### Delete the container if done with it or if you want to recreate from scratch

```
docker stop mysql-rwanda
docker rm mysql-rwanda
```
