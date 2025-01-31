#!/bin/bash
set -e

cat > "${TEMP_MD_CONFIG_FILE}" <<EOF

# Parameters
id:                                   ${TEMP_ID}
pipelineArtifactName:                 ${TEMP_PIPELINE_ARTIFACT_NAME}
imagePropertiesFile:                  ${TEMP_IMAGE_PROPERTIES_FILE}
ciConfig:                             $(echo "${TEMP_CI_CONFIG}" | tr -d '\n')
ciConfigJson:                         $(echo "${TEMP_CI_CONFIG_JSON}" | tr -d '\n')
templateRepository:                   ${TEMP_TEMPLATE_REPOSITORY}
TEMP_CI_CONFIG_DATA:                  $(echo "${TEMP_CI_CONFIG_DATA}" | tr -d '\n')

EOF

if [ -n "${TEMP_ID}" ]; then
    if echo "${TEMP_ID}" | grep -q '[^a-zA-Z0-9_]'; then
        echo "##[error] Parameter id has to consist of characters, numbers and _ only!"
        exit 1
    fi
fi

if [ -z "${TEMP_PIPELINE_ARTIFACT_NAME}" ]; then
    echo "##[error] Parameter pipelineArtifactName must not be empty!"
    exit 1
fi

if [ -z "${TEMP_IMAGE_PROPERTIES_FILE}" ]; then
    echo "##[error] Parameter imagePropertiesFile must not be empty!"
    exit 1
fi


# Check if all objects in "images" have the required keys and non-empty values
if echo "${TEMP_CI_CONFIG_DATA}" | jq -e '
    .images | all(
        . as $img |
        ["type", "tag", "name", "registry"] |
        all($img[.] != null and $img[.] != "")
    )' > /dev/null; then
    # If validation is successful
    echo "Validation successful: All objects in 'images' have the required keys and non-empty values."
else
    # If validation fails
    echo "Validation failed: One or more objects in 'images' are missing required keys or have empty values."
    exit 1
fi