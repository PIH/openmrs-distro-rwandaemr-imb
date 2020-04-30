### Dockerized Deployment Approach

Docker and docker-compose are widely used tools that enable development, testing, and production instances of 
connected services to be deployed consistently and easily across platforms.

In the OpenMRS community today, there are no "official" Docker images or packages that are consistently adopted,
though several groups are utilizing Docker across a combination of development, testing, and production servers.  There
are many best practices that the RwandaEMR project should adopt in order to create high quality and useful Docker images
and docker-compose files.  There are also points in which it would be valuable to work within the OpenMRS community
to create and maintain general purpose images and develop best practice processes that other groups may follow.

#### Approach:

**Identify best practices from existing initiatives**

* https://wiki.openmrs.org/display/docs/Installing+OpenMRS+on+Docker
* https://github.com/openmrs/openmrs-contrib-ansible-docker-compose
* https://github.com/fortitudoinc/fortitudoinc-infra
* https://github.com/PIH/openmrs-module-mirebalais/tree/master/docker/docker-compose
* https://github.com/openmrs/openmrs-sdk/tree/master/maven-plugin/src/main/resources/build-distro
* https://github.com/openmrs-indianaems/openmrs-docker-indianaems
* https://github.com/esaude/esaude-platform-docker
  - https://paper.dropbox.com/doc/eSaude-Container-Infrastructure-sp3X8bmmDTjwDUMvoOzd0
  - https://paper.dropbox.com/doc/eSaude-Docker-Primer-AwyFxv1h49SKSy5X2HR7U
* https://github.com/AMPATH/openmrs-docker 
* https://talk.openmrs.org/t/dockerizing-openmrs/14072
* https://talk.openmrs.org/t/docker-reference-application-in-production/17916
* https://talk.openmrs.org/t/docker-image-for-openmrs/23729
* https://talk.openmrs.org/t/openmrs-docker-images/5475

**Construct base docker file for OpenMRS**

* https://issues.openmrs.org/browse/SDK-259
* This should support a host-mounted [distribution package structure](./distribution-package-structure.md)
* This should go through iterations in the community to security harden it as much as possible
  - See: https://issues.openmrs.org/projects/SDK/issues/SDK-255
  - See: https://issues.openmrs.org/projects/SDK/issues/SDK-254
* Scripts inside the container should be standardized that will: 
  - Ensure artifacts are deployed to appropriate locations prior to server startup
  - Support updates of artifacts that can be updated without requiring a service restart
* Ideally these would be supported by, and hosted within, the OpenMRS community and namespace in Dockerhub
  
**Construct docker-compose files:**

* These should be written to support the specific RwandaEMR deployment scenarios and appropriate services
* Ideally these can be written as a model/template for standard community resources

**Evolve deployment tools and processes to leverage these new packages**

* Create and maintain test server instances utilizing these Docker images and docker-compose files
* Build tools on top of this to support deployment of distribution installs and updates (eg. rsync)
  - Evolution of [Maintenance Tools](https://github.com/PIH/RwandaIMB-RsyncMaintenanceTools)

**Follow-up Community Initiatives:**

* Modify the SDK to use packaging, docker files from above for create-distro and for developments
* Modify the openmrs-distro-referenceapplication and openmrs-distro-platform to reflect these processes
