# Boilerplat-service

Boilerplate for getting quickly getting started with multi-account deployments (staging + prod), using Github Actions and AWS SAM.

## Environments

The sample uses 2 AWS accounts, one for dev and staging, and one for prod.

### Main branch

The main branch triggers a pipeline that

- Applies unit tests
- Builds and packages resources
- Deploys to staging account (`{service-name}.staging.x.com`)
- Performs integration and contract tests
- Deploys to prod. (`{service-name}.prod.x.com`)

### Feature branch

Any branch prefixed with `feature` will trigger deployment of a feature environment available under `{branch-name}-{service-name}.dev.x.com`

### Local

Any `make deploy` commands issued locally will build a development environment available under `{user-login}-{service-name}.dev.x.com` if the user has dev/staging-account credentials.

## Pre-requisites.

- OIDC Github + AWS, ARN of the IAM roles in each account for Github Actions to assume with correct trust relationship set up.
- Create the relevant hosted zones on each of the accounts. Create the relevant NS records for each sub-domain in the central networking account (Account owning the TLD)
- Create the Certificates for TLS and add the relevant parameters (`/${environment}/API/CertificateARN`) in parameter store, so that the cloudformation template can resolve the correct certificate ARN depending on environment.
- The deployment to prod is using the "prod" environment in Github, which should have at least one required reviewer. This triggers a manual approval step before deploying to prod. Set up that environment for the repo.

### Dependencies

- Node 16

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

nvm install 16

nvm use 16
```

- [AWS SAM](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html)
