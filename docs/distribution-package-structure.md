
### Structure of distribution artifact packages

As described in the page describing the distribution [project layout](./distribution-project-layout.md),
this project contains various packages of the RwandaEMR.  For example, the (imb-butaro and imb-rwinkwavu packages
represent a specific set of deployment artifacts that make up the distributions installed at the Butaro and Rwinkwavu
hospitals, respectively.

In OpenMRS, standard distribution artifacts include the OpenMRS core web application (openmrs.war), 
multiple modules that are installed to extend the capabilities of OpenMRS core, various front-end applications that 
are installed and communicate with the web application via web services (owas, esms, etc), and configuration files that
OpenMRS loads in to set up metadata, execute data migrations, and perform maintenance.

Although various packaging options exist, the approach taken here is to build a distribution zip artifact that contains
each of these distinct artifacts in a standard, comprehensive, flexible directory structure.  This directory structure 
is as follows:

|Folder                |Description|
|:------------------   |:------------|
|openmrs_webapps       |openmrs.war, plus any additional wars/webapps if desired, deployed to the same tomcat/webapps|
|openmrs_modules       |omods, deployed to .OpenMRS/modules|
|openmrs_owas          |zips, deployed to .OpenMRS/owa|
|openmrs_config        |files deployed to .OpenMRS/configuration|
|openmrs_migrations    |tbd, enables shipping initial DB sql files +/- DB updates w/ indication if restart required|
|openmrs_esm           |or maybe openmrs_spa or openmrs_mfe, contains artifacts for microfrontend UI|
|openmrs_xyz           |reserved for future OpenMRS needs|
|!openmrs_             |available for distribution use - eg. bahmni_config, bahmni_apps, odoo_config, etc|

The benefits of this approach are the following:

* **Comprehensive**:  All artifacts making up the OpenMRS distribution are present
* **Understandable**: Artifacts are clearly organized 
* **Componentized**:  Each consituent component is easily identifiable.
* **Updateable**:     Configurations can be updated without full deployments. Tools can detect and download only changes.
* **Flexible**:       Package is deployment agnostic and can be installed to Docker, SDK, VM, etc as appropriate
