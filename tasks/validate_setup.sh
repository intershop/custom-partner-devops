#!/bin/bash
set -e

# Check if jq and yq are installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please ensure jq is available."
    exit 1
fi

if ! command -v yq &> /dev/null; then
    echo "Error: yq is not installed. Please ensure yq is available."
    exit 1
fi

echo "jq and yq are available. Proceeding..."