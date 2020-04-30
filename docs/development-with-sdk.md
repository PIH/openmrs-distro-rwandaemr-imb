### Developing using the OpenMRS SDK

The OpenMRS SDK is the standard set of tools that the vast majority of the OpenMRS developer community
uses every day to create local server instances, deploy standard distributions, update modules,
"watch" modules to develop without server restarts, and to enable easy code debugging.  The SDK
provides a host of features and is essential for anyone developing a large OpenMRS distribution like RwandaEMR.

#### Installing the SDK

Please follow the instructions for installation and getting started
at the [OpenMRS SDK Wiki page](https://wiki.openmrs.org/display/docs/OpenMRS+SDK).

#### Preparing a database

For the RwandaEMR, our recommendation is to use Docker to run MySQL for your development environment.  Docker-based 
MySQL images are fast to create, perform equally well, and are extremely flexible.  They also allow for some additional
options that can greatly speed development, that are not easily possible with a non-Docker setup.
For more details, see [development with Dockerized MySQL](./development-with-docker-mysql.md).

In many cases with the RwandaEMR, it is not possible to start up the system without use of an existing database, 
typically a backup of a test server or other existing instance that has been anonymized and cleaned.  

In these cases, there are typically two approaches that one can follow, both supported if you use Docker:

**Get a "mysqldump" file of the source database, and manually import it in**

```
create database openmrs default charset utf8;
use openmrs;
source my-sql-file;
```

**Re-use a volume from a previously created Docker container and mount it in**

- Create a Docker container, making sure you expose the /var/lib/mysql data as a volume [as described here](development-with-docker-mysql.md)
- Create a new database and source in the data you wish to load, as in option 1 above
- Once the data import is complete, create a zip archive on your host machine of /host-location-2
- For future installs, you can start from this initial state by unzipping this and mounting it as the mysql data volume

#### Ensure you have appropriate versions of Java 

* openjdk-8-jdk should be installed.  This should always be the default Java used by your system and by Maven
* If you are running a 1.x version of RwandaEMR (OpenMRS 1.x), you will also need to have a Java 7 installed on your machine
  - https://www.oracle.com/java/technologies/javase/javase7-archive-downloads.html
  - This simply needs to be extracted into a folder somewhere on your machine.
  - You need to note the path where you can find this (typically ```/usr/lib/jvm/jdk1.7.0_80/bin```)

#### Clone and check out project to enable distribution development

* Clone this project
* Choose the appropriate branch or tag based on what you want to build, and check this out.
  - 1.x branch builds to the 1.x release (legacy version running OpenMRS 1.x)
  - master branch builds to the future 2.x release
  - tags build to specific release points in time
* Run "mvn clean install" to put the distribution artifact into Maven

#### Installing a new SDK server based on this

Run "mvn openmrs-sdk:setup" (from any directory):

* Pick the name of the server 
  - This will determine the subdirectory off ~/openmrs/ for the server installation
* For "Distribution" or "Platform" chose "Distribution"
* For distribution version chose "Other...."
* For the distribution, use this module "org.openmrs.distro:<artifactId>:<version>"
   - artifactId: [rwandaemr-imb-butaro](../imb-butaro/pom.xml)
   - artifactId: [rwandaemr-imb-rwinkwavu](../imb-rwinkwavu/pom.xml)
   - version:  Use the version within the ```<parent><version></version></parent>``` tags
* Choose the port to run tomcat on (usually 8080)
* Choose port to debug on (usually 1044)
* Chose how you want to use MySQL - you should use option #3 and configure to point at the Docker container created above.
* For the DB name, chose the existing Rwanda database you want to use: make sure to select the option to NOT overwrite the existing database
* For the DB url, you may need to append some arguments like follows:   &zeroDateTimeBehavior=convertToNull
* Enter mysql user/password for a user that has rights to create databases, etc
* Chose the JAVA HOME you want to use (for 1.x use your Java 7 instance, for 2.x use your Java 8 instance)

#### Running this server

```mvn openmrs-sdk:run```

Updating your SDK environment when module versions change
------------------------------------------------------------------------

* Stop the current server if it is running (Ctrl-C)
* cd into the appropriate package (eg. ```cd imb-butaro``` or ```cd imb-rwinkwavu```)
* run ```mvn openmrs-sdk:deploy -Ddistro=src/main/resources/openmrs-distro.properties```
* Then just start the server via "mvn openmrs-sdk:run"

#### Troubleshooting

Troubleshooting:
------------------

* In Butaro, there is currently an issue with pre-existing billing tables that are causing issues.
  See:  https://pihemr.atlassian.net/browse/RWA-773

* There is an incompatiblity between the Logic Module and the UI Framework regarding Groovy if using the SDK. 
  If everything starts up, but when you try to go to the login page (or any other page) you get a big stack trace 
  that looks like it is due to Groovy, you need to remove the groovy jar file from the lib file.  
  Use the desktop file UI to open the openmrs-1.9.x.war file and remove the groovy jar from the logic omod.
   - Using the system file UI, double click the openmrs war file (ie. ~/openmrs/rwandaemr/openmrs-1.9.11.war)
   - navigate to the WEB-INF/bundledModules folder
   - find the logic omod and double click on the logic omod
   - find the lib/groovy jar file and delete the groovy jar file
   - delete the ~/openmrs/rwandaemr/tmp directory before running 'mvn openmrs-sdk:run'
   - run "mvn openmrs-sdk:run" again
