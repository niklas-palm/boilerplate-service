.ONESHELL:
SHELL := /bin/bash

.PHONY: init.dev
init.dev: ##=> Sets the development environment
	@echo "\nSetting up dev environment for feature branch...\n"
	$(eval export NAME := $(shell whoami))
	$(eval export SERVICE := $(NAME)-$(shell basename $(shell /bin/pwd)))
	$(eval export ENVIRONMENT := dev)
	$(eval export TEMPLATE := template.yaml)

build.fast: ##=> Downloads all dependencies and builds resources using your locally installed dependencies
	sam build

build: ##=> Downloads all dependencies and builds resources within a container
	sam build --use-container

# Deploy target
.PHONY: deploy
deploy: ##=> Deploys the artefacts from the previous build
	@echo Deploying with parameters:
	@echo Service name: $(SERVICE)
	@echo Environment: $(ENVIRONMENT)
	
	sam deploy --stack-name $(SERVICE)-$(ENVIRONMENT) \
		--template $(TEMPLATE) \
		--resolve-s3 \
		--capabilities CAPABILITY_IAM \
		--region $(REGION) \
		--no-fail-on-empty-changeset \
		--parameter-overrides service=$(SERVICE) environment=$(ENVIRONMENT) \
		--tags service=$(SERVICE) environment=$(ENVIRONMENT)

.PHONY: delete
delete: ##=> Deletes the cloudformation stack
	sam delete \
		--stack-name $(SERVICE)-$(ENVIRONMENT) \
		--region $(REGION) \
		--no-prompts

.PHONY: package
package: ##=> Packages template and stores in S3
	sam package \
		--resolve-s3 \
		--region $(REGION) \
		--output-template-file packaged-$(ENVIRONMENT).yaml


##################################
### Used for local development ###
##################################

sync: ##=> Enables hot-reloading, updating the stack's serverless resources' code on save.
	@echo "\nStarting hot-reloading with resources in stack: \"$(STACKNAME)\"\n"

	sam sync --code --watch --stack-name $(STACKNAME)

logs: ##=> Fetchest the latest logs
	@echo "\nFetching latest logs from stack: \"$(STACKNAME)\"\n"

	sam logs --stack-name $(STACKNAME)

logs.tail: ##=> Starts tailing the logs
	@echo "\nStarting to tail the logs from stack: \"$(STACKNAME)\"\n"

	sam logs --stack-name $(STACKNAME)