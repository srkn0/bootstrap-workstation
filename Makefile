.DEFAULT_GOAL := help
SHELL := /usr/bin/env bash

.PHONY: help bootstrap deps lint syntax check run test test-docker clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

deps: ## Install Galaxy role dependencies
	ansible-galaxy install -r requirements.yml

bootstrap: ## Full setup on this machine (./bootstrap.sh)
	./bootstrap.sh

lint: ## Run yamllint + ansible-lint
	yamllint .
	ansible-lint

syntax: ## Playbook syntax check
	ansible-playbook site.yml --syntax-check

check: deps ## Dry run (--check --diff)
	ansible-playbook site.yml --ask-become-pass --check --diff

run: deps ## Apply the playbook on this machine
	ansible-playbook site.yml --ask-become-pass

test: ## Run the Molecule scenario (Docker)
	molecule test

test-docker: ## Quick end-to-end run in a throwaway Ubuntu container
	docker build -f tests/Dockerfile -t bootstrap-workstation:test .

clean: ## Remove local lint/test caches
	rm -rf .molecule .pytest_cache .ansible 2>/dev/null || true
