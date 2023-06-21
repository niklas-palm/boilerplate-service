.ONESHELL:
SHELL := /bin/bash

## Sets DEFAULTS for dev environment (Parameters are overwritten if present in environment)
NAME ?= $(shell whoami)
SERVICE ?= $(NAME)-$(shell basename $(shell /bin/pwd))
ENVIRONMENT ?= dev
REGION ?= eu-west-1
TEMPLATE ?= template.yaml

export NAME
export SERVICE
export ENVIRONMENT
export REGION
export TEMPLATE



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
.PHONY: init.dev
init.dev: ##=> Sets the development environment
	$(eval export NAME := $(shell whoami))
	$(eval export SERVICE := $(NAME)-$(shell basename $(shell /bin/pwd)))
	$(eval export ENVIRONMENT := dev)
	$(eval export REGION := eu-west-1)
	$(eval export TEMPLATE := template.yaml)

.PHONY: sync.code
sync: ##=> Enables hot-reloading, updating the stack's serverless resources' code on save.
	@echo "Starting hot-reloading with resources in stack: \"$(SERVICE)-$(ENVIRONMENT)\""

	sam sync --code --watch --stack-name $(SERVICE)-$(ENVIRONMENT)

.PHONY: logs
logs: ##=> Fetchest the latest logs
	@echo "Fetching latest logs from stack: \"$(SERVICE)-$(ENVIRONMENT)\""

	sam logs --stack-name $(SERVICE)-$(ENVIRONMENT)

.PHONY: tail.logs
logs.tail: ##=> Starts tailing the logs
	@echo "\nStarting to tail the logs from stack: \"$(SERVICE)-$(ENVIRONMENT)\"\n"

	sam logs --stack-name $(SERVICE)-$(ENVIRONMENT)

deploy.dev: build.fast deploy

