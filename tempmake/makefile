.ONESHELL:
SHELL := /bin/bash
REGION := eu-west-1

.PHONY: delete
delete:
	sam delete \
		--stack-name $(SERVICE)-$(ENVIRONMENT) \
		--region $(REGION) \
		--no-prompts

# Example targets for each environment
.PHONY: init.dev
init.dev:
	@echo "\nSetting up dev environment for feature branch...\n"
	$(eval export NAME := $(shell whoami))
	$(eval export SERVICE := $(NAME)-$(shell basename $(shell /bin/pwd)))
	$(eval export ENVIRONMENT := dev)
	$(eval export TEMPLATE := template.yaml)

# Deploy target
.PHONY: deploy
deploy: 
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
