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

test.all: export DIRECTORIES := $(sort $(dir $(wildcard ./functions/*/))) 
test.all:
	for directory in $(DIRECTORIES); do \
		cd $$directory && npm run test ; \
	done	
	

build.fast: ##=> Downloads all dependencies and builds resources using your locally installed dependencies
	sam build

build: ##=> Downloads all dependencies and builds resources within a container
	sam build --use-container

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

delete: ##=> Deletes the cloudformation stack
	sam delete \
		--stack-name $(SERVICE)-$(ENVIRONMENT) \
		--region $(REGION) \
		--no-prompts

package: ##=> Packages template and stores in S3
	sam package \
		--resolve-s3 \
		--region $(REGION) \
		--output-template-file packaged-$(ENVIRONMENT).yaml


##################################
### Used for local development ###
##################################

sync: ##=> Enables hot-reloading, updating the stack's serverless resources' code on save.
	@echo "Starting hot-reloading with resources in stack: \"$(SERVICE)-$(ENVIRONMENT)\""

	sam sync --code --watch --stack-name $(SERVICE)-$(ENVIRONMENT)

logs: ##=> Fetchest the latest logs
	@echo "Fetching latest logs from stack: \"$(SERVICE)-$(ENVIRONMENT)\""

	sam logs --stack-name $(SERVICE)-$(ENVIRONMENT)

logs.tail: ##=> Starts tailing the logs
	@echo "\nStarting to tail the logs from stack: \"$(SERVICE)-$(ENVIRONMENT)\"\n"

	sam logs --stack-name $(SERVICE)-$(ENVIRONMENT)

deploy.dev: build.fast deploy

