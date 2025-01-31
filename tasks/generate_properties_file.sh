#!/bin/bash
set -e

# Create a temporary folder for storing intermediate files
TMP_CUSTOM_DIR=$(mktemp -d -t ci-XXXXXXXXXX)
IMAGE_PROPERTIES_FILE_PATH="${TMP_CUSTOM_DIR}/${TEMP_IMAGE_PROPERTIES_FILE}"

# Generate YAML file
echo "${TEMP_CI_CONFIG_DATA}" | yq -p=json -o=yaml > "${IMAGE_PROPERTIES_FILE_PATH}"

# Print the contents of the imageProperties file
echo "###### File ${IMAGE_PROPERTIES_FILE_PATH} ######"
cat "${IMAGE_PROPERTIES_FILE_PATH}"
echo "###### File end ######"

# Validate YAML
if yq "${IMAGE_PROPERTIES_FILE_PATH}" >/dev/null; then
    echo "YAML file generated successfully."
else
    echo "Failed to generate YAML file."
    exit 1
fi

# Upload the imageProperties file as an artifact
echo "##vso[artifact.upload containerfolder=image;artifactname=${TEMP_PIPELINE_ARTIFACT_NAME}]${IMAGE_PROPERTIES_FILE_PATH}"