openmrs-distro-rwandaemr
==========================

This OpenMRS distribution project is intended to represent a common distribution as well as specific implementation
distributions within the Rwanda EMR ecosystem.

Currently this distribution supports two specific distributions, which are represented as sub-modules:
* imb-butaro
* imb-rwinkwavu

The master branch of this project is intended to represent the mainline of development and the next major release.
In addition to the master branch, this project supports maintenance branches that reflect prior or existing production
releases of the software, in order to enable reproduction of those environments in the future, and to support
current production instances.  These maintenance branches may require changes and releases as support and new minor releases
are issued during the course of development for the next major release.

For more information on the specific distribution versions of interest, see the below section on SDK setup.

## CI and release process

## Running with OpenMRS SDK

### Pre-requisites

#### Install Docker

Follow the instructions for your operating system to [install Docker](https://docs.docker.com/engine/install/ubuntu/).
Typically you will also want to enable your user permissions to [execute Docker commands without sudo](https://docs.docker.com/engine/install/linux-postinstall/).

#### Install Java 7 and Java 8 and Maven 3

Java 7 is required to run OpenMRS versions prior to 2.x.  It can be 
[downloaded from here](https://www.oracle.com/java/technologies/javase/javase7-archive-downloads.html) 
and extracted into your directory of choice.

Java 8 is required to run OpenMRS verisons at 2.0 and higher.  Java 8 is also typically what is used to run the SDK 
and build modules and to set as the default Java that is executed by Maven.  This _must_ be OpenJDK, not Oracle.
For Ubuntu users, the package you should install is ```sudo apt-get install openjdk-8-jdk```

#### Install the OpenMRS SDK

Install the OpenMRS SDK [as described here](https://wiki.openmrs.org/display/docs/OpenMRS+SDK#OpenMRSSDK-Installation)

### Process for creating a local Rwanda instance using the SDK

#### Create a new database on your machine for your SDK

For IMB, there are 2 variations to choose from - Rwinkwavu and Butaro.  These represent the two distinct sync networks
that exist, and thus (assuming all servers are synced) represent the two unique systems that are in place.  Due to history,
these databases differ in certain ways.  The systems run different sets of modules, and there are are some differences in 
metadata.

There are starter databases available to choose from based on the level of anonymization and minimization that is required.
These are distributed as zipped "mysql data" directories that can be mounted as a volume into a mysql:5.6 Docker container.
Full instructions are available for [PIH/IMB systems here](https://pihemr.atlassian.net/wiki/x/goCRIQ).

#### Create a new SDK "server" that uses this DB

Detailed instructions on SDK usage are available on the [OpenMRS SDK Wiki page](https://wiki.openmrs.org/display/docs/OpenMRS+SDK). 

There are some specific variations to the normal process that one should be aware of when building the Rwanda EMR.
Details behind all of these are listed as relevant in the following sections.

Run "mvn openmrs-sdk:setup" (from any directory)
1. Pick the name of the server (eg. if you choose rwandaemr, all server files will be located in ~/openmrs/rwandaemr)
2. Choose "Distribution" -> "Other"
3. Which distribution you choose depends on which version of the RwandaEMR you want to run.
   * org.openmrs.distro:rwandaemr-imb-butaro:1.0.0 - The current version running in Butaro production as of April 2020
   * org.openmrs.distro:rwandaemr-imb-rwinkwavu:1.0.0 - The current version running in Rwinkwavu production as of April 2020
   * org.openmrs.distro:rwandaemr-imb-butaro:2.0.0-SNAPSHOT - The current development version for Butaro
   * org.openmrs.distro:rwandaemr-imb-rwinkwavu:2.0.0-SNAPSHOT - The current development version for Rwinkwavu
4. Choose the port to run tomcat on (usually 8080)
5. Choose port to debug on (usually 1044)
6. Chose how you want to use MySQL... via a local install of MySQL or docker, you should use option #3
   * Currently there is no option to have a new empty DB created for you with the RwandaEMR.  This is TBD.
   * Make sure you choose the default option to NOT overwrite the existing database
   * Choose the name of the Docker container that you created above
   * Typically just use the root MySQL user and password, which was also setup above
   * When setting the DB URL, you'll need to user the Docker mapped port (often 3308) and database name (often openmrs)
   * The DB URL will also need the following options appended:
   ```autoReconnect=true&sessionVariables=default_storage_engine%3DInnoDB&useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull```
7. For Java version, choose the Java 7 installation that you set up in the pre-requisities above.

Once setup, simply run ```mvn openmrs-sdk:run -DserverId=yourserverid```

#### Modify this server to use new versions

You can use standard SDK commands to install new versions of modules.
You can also install locally from your own build environment.
You can also clone this project, update the POM, and build this project, then install again from above or re-deploy.
* To redeploy, from the base directory of this project run: ```mvn openmrs-sdk:deploy -Ddistro=<imb-butaro/imb-rwinkwavu>/src/main/resources/openmrs-distro.properties```
Further instructions TBD.

#### Troubleshooting:

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


#### Other OpenMRS SDK tips and tricks

You can use the OpenMRS SDK to "watch" modules (so that an openmrs-sdk:run automatically deploys any changes you make to those modules).  
For more details, [read more about the SDK here](https://wiki.openmrs.org/display/docs/OpenMRS+SDK#OpenMRSSDK-Installation)

## CI and release process

This project uses Github Actions to orchestrate CI.  Each of the CI processes is reflected in a "workflow" file
within the [.github/workflows](.github/workflows) directory.

Please see each of these files and the comments within them for details on what each of them do.

In summary, these workflows provide the following services:

* Builds and executes unit tests against all pull requests opened against the master branch
* Builds, executes unit tests, and publishes a new snapshot version from the master branch and specified maintenance branches on every commit.
* Performs a tagged non-snapshot release upon execution of a specific command
