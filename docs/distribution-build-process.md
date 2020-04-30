### Distribution Build Process

During the build process, each of the distribution packages in the RwandaEMR generates a build artifact with a 
[standard structure](./distribution-package-structure.md).  This process uses various Maven plugins and pom.xml
configurations.  Without a standard community process for building to the intended structure, with 
tools that most implementations follow to minimize boilerplate and facilitate standardization of packaging approaches,
this project adapts from mature community efforts in order to develop a best practice for the RwandaEMR and with an 
intention to and present these back to the OpenMRS community for consideration as broader standards, if useful.

Resources:

* Distributions that roll their own pom.xml
  - https://github.com/mekomsolutions/openmrs-distro-cambodia/blob/master/pom.xml
* Distributions that use the [OpenMRS SDK](https://github.com/openmrs/openmrs-sdk)
  - https://github.com/openmrs/openmrs-distro-referenceapplication/blob/master/package/pom.xml
* Distributions that take a piecemeal approach:
  - https://github.com/PIH/openmrs-module-mirebalais/tree/master/distro
  - https://github.com/PIH/openmrs-config-pihemr
  - https://github.com/PIH/openmrs-config-ces
  - See: https://github.com/openmrs/openmrs-contrib-packager-maven-plugin

Approach:

* Leverage and improve community tooling where possible
  - [openmrs-sdk](https://github.com/openmrs/openmrs-sdk/tree/master/maven-plugin/src/main/java/org/openmrs/maven/plugins)
  - [openmrs-packager](https://github.com/openmrs/openmrs-contrib-packager-maven-plugin)
* Develop a parent pom that eliminates duplication of code across various distribution package projects
* Create custom plugin capabilities to further reduce boilerplate and add standardization:
  - Standard zip file packaging of artifacts, elimination of assembly.xml from all projects
  - Generation of openmrs-distro.properties file from pom.xml configuration

