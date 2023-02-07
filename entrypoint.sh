#!/usr/bin/env bash
# /entrypoint.sh
## ============================================== ##
## Entrypoint script for the Jeak-Framework docker image ##
## ============================================== ##

## Prepare ##
VERSION="$JEAKBOT_VERSION"
if [[ -z "$VERSION" ]]; then
    VERSION="1.0.0"
fi

if [[ "$JEAKBOT_SNAPSHOT" = "true" ]]; then
    VERSION="${VERSION}-SNAPSHOT"
fi

ARTIFACT_NAME="/opt/jeakbot.tar.gz"
DIST_REPO="https://nexus.fearnixx.de/repository/jeakbot-dist"

## Install / Update ##
if [[ ! -e jeakbot.jar ]]; then
#    printf "Installing Jeakbot V: ${VERSION}...\n"
#    if ! curl -o "$ARTIFACT_NAME" "${DIST_REPO}/${ARTIFACT_NAME}"; then
#        printf "Failed to download artifact!\n"
#        exit 1
#    fi

    printf "Extracting archive...\n"
    if ! tar -xf "$ARTIFACT_NAME"; then
        printf "Failed to extract archive!\n"
        exit 1
    fi

    printf "Renaming jarfile...\n"
    if ! mv jeakbot-*.jar jeakbot.jar; then
        printf "Failed to rename jarfile!\n"
        exit 1
    fi
fi

if [[ ! -e ./utils/trusted_roots.jks ]]; then
    echo "Building truststore"
    cd ./utils
    curl -SsLo lets-encrypt-x3-cross-signed.pem https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem.txt
    if ! ./create_keystore.sh; then
        echo "Failed to build keystore!"
    fi
    cd ..
fi

## Startup ##
# Output Current Java Version
java -version

# Replace Startup Variables
# Example startup line: java -Xmx{{SERVER_XMX}}M -Xms{{SERVER_XMS}}M -cp jeakbot.jar:libraries/* {{EXTRA_JVM}} de.fearnixx.jeak.Main{{EXTRA_APP}}
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
