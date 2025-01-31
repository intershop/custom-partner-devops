#!/bin/bash
set -e

# Adds a build tag based on the SourceBranch type (Pull Request, Tag, or Branch) for better build classification.

echo "Checking Build.SourceBranch: ${BUILD_SOURCE_BRANCH}"

if [[ "${BUILD_SOURCE_BRANCH}" =~ ^refs/pull/ ]]; then
    echo "##vso[build.addbuildtag]SourceType_Git-PullRequest"
elif [[ "${BUILD_SOURCE_BRANCH}" =~ ^refs/tags/ ]]; then
    echo "##vso[build.addbuildtag]SourceType_Git-Tag"
elif [[ "${BUILD_SOURCE_BRANCH}" =~ ^refs/heads/ ]]; then
    echo "##vso[build.addbuildtag]SourceType_Git-Branch"
else
    echo "##vso[build.addbuildtag]SourceType_Unknown"
fi