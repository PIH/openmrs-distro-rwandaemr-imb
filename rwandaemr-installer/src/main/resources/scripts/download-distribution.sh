#!/bin/bash -eu

## load variables from the vars.txt file
source vars.txt

ARTIFACT_ID="${distribution}"
VERSION="${version}"

if [ "$env_type" == "demo" -o "$env_type" == "prod" -o "$env_type" == "test" ]; then
  TARGET_DIR="/opt/${parent_dir}/distribution"
else
  TARGET_DIR="${parent_dir}/distribution"
fi

function usage() {
  echo "USAGE:"
  echo "Download the distribution with the given ARTIFACT_ID and VERSION to the given TARGET_DIR."
  echo "The TARGET_DIR must exist and be a valid directory."
  echo ""
  echo "  ./download-distribution.sh [ARTIFACT_ID] [VERSION] [TARGET_DIR]"
  echo "  eg."
  echo "  ./download-distribution.sh rwandaemr-imb-butaro 2.0.0-SNAPSHOT /tmp/omrs"
  exit 1
}

if [[ -z "$ARTIFACT_ID" ]]; then
  usage
fi

if [[ -z "$VERSION" ]]; then
  usage
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  usage
fi

ARTIFACT="org.openmrs.distro:$ARTIFACT_ID:$VERSION:zip:distribution"

ZIP_FILE="$TARGET_DIR/$ARTIFACT_ID-$VERSION-distribution.zip"
MAVEN_SETTINGS_FILE="$TARGET_DIR/maven-settings.xml"

cat > $MAVEN_SETTINGS_FILE << EOF
<?xml version="1.0" encoding="UTF-8"?>
<settings>
  <profiles>
    <profile>
      <repositories>
        <repository>
          <id>openmrs-repo</id>
          <name>OpenMRS Nexus Repository</name>
          <url>http://mavenrepo.openmrs.org/nexus/content/repositories/public</url>
        </repository>
      </repositories>
      <id>openmrs</id>
    </profile>
  </profiles>
  <activeProfiles>
    <activeProfile>openmrs</activeProfile>
  </activeProfiles>
</settings>
EOF

mvn dependency:get -U -Dartifact=$ARTIFACT -s $MAVEN_SETTINGS_FILE
mvn dependency:copy -Dartifact=$ARTIFACT -DoutputDirectory=$TARGET_DIR
unzip $ZIP_FILE -d $TARGET_DIR

rm $ZIP_FILE
rm $MAVEN_SETTINGS_FILE
