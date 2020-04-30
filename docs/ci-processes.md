### Continuous Integration Processes and Overview

Continuous Integration (CI) is the process by which we automate and standardize the testing, building, deployment, 
and release of  both our underlying distribution artifacts and overall distribution packages.  
The process also enables workflows and pipelines to automatically keep test and demo servers up-to-date given various 
triggers, to facilitate code review and collaboration, and to issue alerts for problems within this process.  CI enables
various groups to collaborate with each other by automatically building and sharing new code artifacts upon each commit.

In the OpenMRS community, there are a number of tools in place to facilitate CI:

#### [OpenMRS Bamboo](https://ci.openmrs.org/)

For OpenMRS core and community-supported modules, there is an OpenMRS Bamboo CI server which is responsible for building 
and deploying both releases and new snapshot versions of all artifacts after each commit.

#### [PIH Bamboo](http://bamboo.pih-emr.org:8085/)

Partners In Health also maintains a Bamboo CI server which is responsible for building and deploying artifacts for most
of the software hosted under the PIH github organization.

#### [Travis CI](https://ci.openmrs.org/)

For OpenMRS core and community-supported modules, most of these are configured to execute jobs running at Travis CI, which
provide alerts and notifications for any build or test failures on commits and pull requests.

#### [Github Actions](https://github.com/features/actions)

For the RwandaEMR project, we have begun to establish the use of Github Actions for CI automation.
Github Actions are configured on a per-repository basis, and contain those workflows that you wish to configure 
for that repository.  The advantage of this platform for the RwandaEMR project is that anyone
who has write-access to the repository can create or edit a CI workflow.  
Anyone can also easily view all of the details of each workflow within the code project itself.  
See the [workflows defined here](../.github/workflows) for how this is configured for this project.
The clear benefit for the RwandaEMR is transparency and accessibility to all collaborators within the project.

##### Standard Workflows

The [workflows defined in this project](../.github/workflows) provide a good overview of the standard processes:

**verify-prs:**
For every pull request that is issued against the configured branches (typically just master), 
this job runs a “mvn verify”, which compiles, tests, and verifies that the there are no errors.

**deploy-snapshots:**
For every commit pushed to the configured branches (typically master plus any active maintenance branches, 
this job runs a “mvn deploy”, which compiles, executes tests, and verifies that this builds without errors, 
and if so, deploys to the OpenMRS Maven Snapshots repository that is configured in the distributionManagement
 section of the [pom.xml](../pom.xml)
 
For certain modules, we have started adding in capabilities to also detect when Maven dependencies have been updated
in the Maven repository, and triggering new builds under these circumstances.  Currently, this is being piloted 
as an approach in the [rwandareports module](https://github.com/PIH/openmrs-module-rwandareports).  Specifically:
* https://github.com/PIH/openmrs-module-rwandareports/blob/master/pom.xml#L222
* https://github.com/PIH/openmrs-module-rwandareports/blob/master/.github/workflows/deploy-snapshots.yml

**perform-release:**
This job exists to perform a versioned, non-SNAPSHOT release.  This is not automatically executed, 
but rather is initiated by an explicit, authenticated REST request.  This job runs the following maven goals:

```mvn release:prepare```
- Removes “-SNAPSHOT” from pom.xml files and commits
- Tags this commit with the version number
- Increments the version in the pom.xml to the next snapshot version, and commits this

```mvn release:perform```
- Checks out the tag with the version created in the release:prepare step
- Builds the code artifacts
- Deploys these to the OpenMRS Maven repository that is configured in the distributionManagement section of the pom

```mvn deploy```
- Builds the next snapshot version created at the end of release:prepare
- Deploys this to the OpenMRS Maven snapshots repository that is configured in the pom

To initiate the release workflow one would take the following steps:
* [Create a personal access token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line) 
to authenticate into Github with minimal permissions (public_repo and write:repo_hook)
* In a terminal, set the GITHUB_TOKEN environment variable to this token value:
```export GITHUB_TOKEN=areallylongtokenthatisgeneratedingithub```
* Issue a request to hit the deployment endpoint, replacing <org>/<repo> as appropriate (eg. PIH/openmrs-distro-rwandaemr)
```
curl  -H "Authorization: token $GITHUB_TOKEN" \
      -H "Accept: application/vnd.github.everest-preview+json"  \
      -H "Content-Type: application/json" \
      --request POST \
      --data '{"event_type": "perform-release"}' \
      https://api.github.com/repos/<org>/<repo>/dispatches
```

##### Enabling Github Actions in a new repository

Each repository that wishes to use Github Actions for CI will need to follow these steps:

* Copy and paste the entire [.github/workflows] directory from an existing project to your module’s codebase
* Modify these as appropriate to suit your needs
* Ensure your pom.xml file for your module is updated with the correct deployment settings that work with Github Actions:
  - SCM section should use the “scm:git:https://github.com” option:
```xml
<scm>
 <developerConnection>scm:git:https://github.com/...</developerConnection>
 <url>https://github.com/...</url>
 <tag>HEAD</tag>
</scm>
```
  - Distribution management section should use the https://openmrs.jfrog.io domain, and point to a repository to which
  the author has appropriate access credentials:

```xml
<distributionManagement>
   <repository>
      <id>openmrs-repo-modules-pih</id>
      <name>OpenMRS PIH Modules</name>
      <url>https://openmrs.jfrog.io/artifactory/modules-pih/</url>
   </repository>
   <snapshotRepository>
      <id>openmrs-repo-modules-pih-snapshots</id>
      <name>OpenMRS PIH Module Snapshots</name>
      <url>https://openmrs.jfrog.io/artifactory/modules-pih-snapshots/</url>
   </snapshotRepository>
</distributionManagement>
```
* Ensure all secrets referenced in the copied workflows are present in your new repository (search for secrets.).  
  - Typically this will be just “BINTRAY_PASSWORD”, which is needed to authenticate into Bintray
* Add a new “secret” with this key and value in the Github repository for your project (Settings → Secrets)
  - If you do not have admin access to the repository, but do have write access, you can use the Github REST API for this.
* Check-in and push the updates from the above steps to your repository
* Navigate to the “Actions” area in github and confirm that the jobs you expect to run are successfully run.
