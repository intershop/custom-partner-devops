# custom-partner-devops

## Overview

Repository *custom-partner-devops* provides an *Azure DevOps Pipeline* template, which can be used by custom projects, that are managed inside *Intershops Commerce Platform*.

This template helps streamline the creation of required pipeline artifacts and other necessary components, ensuring a smooth transition into the *Continuous Deployment (CD) process* used by Intershop.  
The template should be used as-is. Any custom modifications or extensions should be implemented outside of this template.  

## How to use the pipeline template

The template must be integrated into an existing CI pipeline. Modify your current pipeline definition to include the following reference:  

```
# azure-pipelines.yml

resources:
  repositories:
    - repository: custom-partner-devops
      type: github
      endpoint: <GitHub Connection>
      name: intershop/custom-partner-devops
      ref: refs/heads/stable/v1

stages:
  - stage: CI
    <Current CI Stage with Docker Image Creation>
  - stage: CIConfig
    dependsOn: CI
    jobs:
    - template: ci-job-helper-template.yml@custom-partner-devops
      parameters:
        <PARAMETER>

```

The template can be seamlessly added to an existing CI pipeline by referencing it within a job. This allows for the automatic generation of required artifacts and dependencies while keeping the overall pipeline structure intact.  

## Parameters

| Parameter Name | Type | Description | Default Value | Required |  
|---|---|---|---|---|  
| id | string | Unique identifier for each job when `ci-job-helper-template.yml` is used in a loop. Can only contain characters, numbers, and underscores. Also used to extend the names of files published in extensions. | `''` | No |  
| dependsOn | string | Enables seamless integration with custom jobs. The parameter is passed directly to the `dependsOn` property of the job. | `''` | No |  
| condition | string | Enables conditional execution within the CI pipeline. The parameter is passed directly to the `condition` property of the job. | `''` | No |  
| agentPool | string | Specifies the name of the agent pool. | `''` | Yes |  
| jobTimeoutInMinutes | number | Defines the maximum job execution time in minutes. | `5` | No |  
| jobContinueOnError | boolean | Determines whether subsequent jobs should continue running even if this job fails. | `false` | No |  
| pipelineArtifactName | string | Name of the CI pipeline artifact. | `image_artifacts` | No |  
| imagePropertiesFile | string | Name of the file to be analyzed. | `imageProperties.yaml` | No |  
| ciConfig | object | CI configuration in Azure Pipeline object format. Allows passing structured key-value pairs directly in the YAML pipeline. | `{}` | Yes, if `ciConfigJson` is not set |  
| ciConfigJson | string | CI configuration as a JSON string. If both `ciConfig` (object) and `ciConfigJson` (string) are provided, `ciConfigJson` takes precedence. | `""` | Yes, if `ciConfig` is not set |  
| templateRepository | string | Resource name of this template repository. | `ci-custom-partner-devops` | No |  

### Using `ciConfig` (YAML Object Format)  

This parameter allows passing a structured object directly in the pipeline. Example usage:  

```yaml
parameters:
  ciConfig:
    images:
      - type: icm
        tag: 1.0.0
        name: exampleImage/icm
        registry: "exampleacr.io"
      - type: service
        tag: 2.3.0
        name: exampleImage/service
        registry: "exampleacr.io"
```

### Using `ciConfigJson` (JSON String Format)  

This parameter allows passing the same configuration as a JSON string, which is useful for dynamically generated configurations. If both `ciConfig` and `ciConfigJson` are provided, `ciConfigJson` takes precedence.  

Example usage:  

```yaml
parameters:
  ciConfigJson: |
    {
      "images": [
        {
          "type": "icm",
          "tag": "1.0.0",
          "name": "exampleImage/icm",
          "registry": "exampleacr.io"
        }
      ]
    }
```
### Explanation of Values

- images: The name of the list where all image objects must be defined.
- type: The individual type values must be unique and are required for proper identification in the CD process. It should not be "pwa", "icm", or "iom". Examples of valid types include "customProxy", "customApp<AppName>".
- tag: The tag of the Docker image created by the CI pipeline.
- name: The name of the image created by the CI pipeline.
- registry: The registry where the image created by the CI pipeline is stored.

The full name of the Docker image follows this format:
`<Registry>/<Name>:<Tag>`

This metadata is used to track the generated Docker images and their associated attributes.

## Important information:

Always refer to the `stable/v1` branch or a tag as the main/master branch is under constant development and breaking changes cannot be excluded. The `stable/v1` represents a branch that is backward compatible and does not contain any breaking changes.