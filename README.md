openmrs-distro-rwandaemr
==========================

This project represents the OpenMRS RwandaEMR set of distribution packages as configured for use at IMB.
The intention of this distribution is to mostly inherit from the RwandaEMR distribution parent project
at https://github.com/Rwanda-EMR/openmrs-distro/rwandaemr, but with those modifications that are appropriate for IMB
sites, including functionality like the synchronization module.

[Documentation is in the wiki located here](https://github.com/PIH/openmrs-distro-rwandaemr-imb/wiki).

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

