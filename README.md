# Boilerplat-service

Boilerplate for getting quickly getting started with multi-account deployments (staging + prod), using Github Actions and AWS SAM.

## Pre-requisites.

- OIDC Github + AWS, ARN of the IAM roles in each account for Github Actions to assume with correct trust relationship set up.
- Create the relevant parameters (`/${environment}/API/CertificateARN`) in parameter store, and the relevant NS records in the central networking account for each hosted zone.
- The deployment to prod is using the "prod" environment in Github, which should have at least one required reviewer. This triggers a manual approval step before deploying to prod. Set up that environment for the repo.
