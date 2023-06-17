# Boilerplat-service

Boilerplate for getting quickly getting started with multi-account deployments (staging + prod), using Github Actions and AWS SAM.

## Pre-requisites.

- OIDC Github + AWS, ARN of the IAM roles in each account for Github Actions to assume with correct trust relationship set up.
- The deployment to prod i using the "prod" environment in Github, which should have at least one required reviewer. This triggers a manual approval step before deploying to prod. Set up that environment for the repo.
