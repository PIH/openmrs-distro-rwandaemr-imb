openmrs-distro-rwandaemr
==========================

This project represents the OpenMRS RwandaEMR set of distribution packages as configured for use at IMB.
The intention of this distribution is to mostly inherit from the RwandaEMR distribution parent project
at https://github.com/Rwanda-EMR/openmrs-distro/rwandaemr, but with those modifications that are appropriate for IMB
sites, including functionality like the synchronization module.

[Documentation is in the wiki located here](https://github.com/PIH/openmrs-distro-rwandaemr-imb/wiki).

## Setting up a development environment with the OpenMRS SDK

First identify the distribution you want to set up.  There are currently 2 options:

* rwandaemr-imb-rwinkwavu
* rwandaemr-imb-butaro

### Prerequisites

* Java 8 (`sudo apt-get install openjdk-8-jdk`)
* Maven 3 (`sudo apt-get install maven`)
* MySQL 8 (either a native install or using Docker)
* OpenMRS SDK (see https://wiki.openmrs.org/display/docs/OpenMRS+SDK#OpenMRSSDK-Installation)

### Setup

The OpenMRS SDK allows you to have multiple "servers" installed.  It organizes each of these servers on your computer
as a subdirectory within an overall `~/openmrs` directory.

Each server must therefore be given a unique name.  This name will be the name of the directory under `~/openmrs` and 
will be used to identify the particular server of interest when running all SDK commands.

Good server names are concise and informative.  For example, if you are setting up an SDK server with a database backup from the
`rwinkwavu` facility, then a good server name for this would be `rwinkwavu`.

In the commands below, whenever you see **<server_id>**, you should replace this with you chosen serverId name

* `mvn openmrs-sdk:setup -DserverId=<server_id>`
* Option #2:  2.x Distribution
* Option #6:  Other 
  * Enter the specific variation and version you want to install, eg: org.openmrs.distro:rwandaemr-imb-rwinkwavu:2.1.0-SNAPSHOT
* Port:  8080
* Debug port:  5000
* Database:  If you have a native MySQL install into which you have restored a backup, use option 1 here
  * Enter the appropriate url, username, and password for accessing that database when prompted 
  * Setup with existing data - Yes
* Java home - Pick the Java 8 installation that is on your system

=======================================================

## Developer tips

To build and install a specific version of the distribution into an SDK server, you would run the [./install.sh](./install.sh)
script from this directory as follows:

* Rwinkwavu:  `./install.sh rwinkwavu <server_id>`
* Butaro:  `./install.sh butaro <server_id>`

If you are only working on a small aspect of configuration, you can also often copy files directly into your SDK and use 
the administrative tools to refresh your server, for more rapid testing.  

For example, if you are editing new message properties, you can get these to appear without rebuilding and restarting as follows:

`cp -r configuration/messageproperties/* ~/openmrs/<server_id>/configuration/messageproperties/`

Then, navigate to http://localhost:8080/openmrs/imbemr/admin/configuration.page and click "Refresh Message Properties"

Also, if you are editing appframework configuration files, you can update these without rebuilding and restarting as follows:

`cp -r configuration/appframework/* ~/openmrs/<server_id>/configuration/appframework/`

Then, navigate to http://localhost:8080/openmrs/imbemr/admin/configuration.page and click "Refresh Apps and Extensions"

