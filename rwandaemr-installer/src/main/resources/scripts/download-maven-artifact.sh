#!/bin/bash -eu

GROUP_ID=$1
ARTIFACT_ID="$2"
VERSION="$3"
CLASSIFIER="$4"
TYPE="$5"
TARGET_DIR="$6"

function usage() {
  echo "USAGE:"
  echo "Download the Maven Artifact with the given specification to the given TARGET_DIR."
  echo "The TARGET_DIR must exist and be a valid directory."
  echo ""
  echo "  ./download-maven-artifact.sh [GROUP_ID] [ARTIFACT_ID] [VERSION] [CLASSIFIER] [TYPE] [TARGET_DIR]"
  echo "  eg."
  echo "  ./download-maven-artifact.sh org.openmrs.distro rwandaemr-imb-butaro 2.0.0-SNAPSHOT distribution zip /tmp/omrs"
  echo "  ./download-maven-artifact.sh org.openmrs.distro rwandaemr-installer 2.0.0-SNAPSHOT installer zip /tmp/omrs"
  exit 1
}

if [[ -z "$GROUP_ID" ]]; then
  usage
fi

if [[ -z "$ARTIFACT_ID" ]]; then
  usage
fi

if [[ -z "$VERSION" ]]; then
  usage
fi

if [[ -z "$CLASSIFIER" ]]; then
  usage
fi

if [[ -z "$TYPE" ]]; then
  usage
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  usage
fi

ARTIFACT="$GROUP_ID:$ARTIFACT_ID:$VERSION:$TYPE:$CLASSIFIER"

DOWNLOADED_FILE="$TARGET_DIR/$ARTIFACT_ID-$VERSION-$CLASSIFIER.$TYPE"

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
mvn dependency:copy -Dartifact=$ARTIFACT -DoutputDirectory=$TARGET_DIR -Dmdep.useBaseVersion=true
unzip $DOWNLOADED_FILE -d $TARGET_DIR

rm $DOWNLOADED_FILE
rm $MAVEN_SETTINGS_FILE
