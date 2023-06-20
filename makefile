.ONESHELL:
SHELL := /bin/bash
NAME := $(shell whoami)
DIR := $(shell basename $(shell /bin/pwd))
STACKNAME := $(NAME)-$(DIR)
REGION := eu-west-1

# .PHONY: all 

build: ##=> Downloads all dependencies and builds a deployable artefact
	sam build

deploy: ##=> Deploys the artefacts from the previous build
	@echo "\nUsing inferred name \"$(STACKNAME)\" to prefix resources \n"

	sam deploy --stack-name $(STACKNAME) \
		--resolve-s3 \
		--capabilities CAPABILITY_IAM \
		--region $(REGION) \
		--no-fail-on-empty-changeset \
		--parameter-overrides service=$(STACKNAME) environment=dev \
		--tags dev=$(NAME) environment=dev 

sync: ##=> Enables hot-reloading, updating the stack's serverless resources' code on save.
	@echo "\nStarting hot-reloading with resources in stack: \"$(STACKNAME)\"\n"

	sam sync --code --watch --stack-name $(STACKNAME)

logs: ##=> Fetchest the latest logs
	@echo "\nFetching latest logs from stack: \"$(STACKNAME)\"\n"

	sam logs --stack-name $(STACKNAME)

logs.tail: ##=> Starts tailing the logs
	@echo "\nStarting to tail the logs from stack: \"$(STACKNAME)\"\n"

	sam logs --stack-name $(STACKNAME)

delete: ##=> Deletes the cloudformation stack
	@echo "\nDeleting dev stack with name \"$(STACKNAME)\"\n"

	sam delete \
		--stack-name $(STACKNAME) \
		--region $(REGION) \
		--no-prompts
		


