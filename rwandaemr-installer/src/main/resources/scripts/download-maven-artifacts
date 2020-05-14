#!/bin/bash -eu

ARTIFACT_ID="$1"
VERSION="$2"
TARGET_DIR="$3"
CLASSIFIER="$4"

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

ARTIFACT="org.openmrs.distro:$ARTIFACT_ID:$VERSION:zip:$CLASSIFIER"

ZIP_FILE="$TARGET_DIR/$ARTIFACT_ID-$VERSION-$CLASSIFIER.zip"
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