### Layout of distribution project codebase

The distribution project codebase contains the docker files, scripts, and documentation needed for
packaging and deployment, and tools to support development, testing, and continuous integration workflows.

A distribution project may have one or more distinct distribution artifact packages that it produces.  Each of these is
defined within a folder whose name matches the artifactId for the packaged artifact.  Given the common practice within
the OpenMRS ecosystem or using the generic "org.openmr.distro" group, if this approach is taken it is essential to
ensure the artifactId uniquely represents the specific distribution itself.

For the RwandaEMR, the convention is for each distribution package to have a "rwandaemr-" prefix, followed by a
suffix that uniquely identifies this particular package.  For example, at IMB, there is are slight variations 
between the packages deployed at Rwinkwavu and Butaro hospitals.  These are represented by distinct packages in the project 
structure and produce two related by distinct distribution packages:

* rwandaemr-imb-rwinkwavu
* rwandaemr-imb-butaro 

For the RwandaEMR, we will be including several distinct packages that represent variations of the RwandaEMR that
are implemented across the country.  

The following is a summary of the project layout:

|Folder                  |Description|
|:------------------     |:------------|
|.github/workflows       |Continuous integration configuration files. See [CI processes](./ci-processes.md)|
|docker                  |Dockerfile(s), docker-compose files.|
|docs                    |Detailed documentation, linked to from [README](../README.md)|
|rwandaemr-imb-butaro    |Maven sub-module, responsible for building package containing Butaro distribution package|
|rwandaemr-imb-rwinkwavu |Maven sub-module, responsible for building package containing Rwinkwavu distribution package|
|scripts                 |Intended for any shell scripts, Vagrantfiles, etc. useful for dev/admin tasks|
|tests                   |Intended for functional test scripts, automated ui/selenium/cucumber tests, etc|
|README.md               |[Top-level documentation file](../README.md)|
|pom.xml                 |Parent pom.  Also useful as a parent pom for distribution-specific modules|

---
This is an adaptation based on:
* https://github.com/openmrs/openmrs-distro-referenceapplication

