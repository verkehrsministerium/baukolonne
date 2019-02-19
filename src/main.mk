include ../core.mk
include ../semver.mk
include ../git.mk
include ../docker.mk

USAGE := "Usage: make [var=value] [commands...]\n\n"
EXTRA_HELP := ""

.PHONY: help major minor patch release image build test package publish

help: ## Display this help message
	@printf $(USAGE)
	@printf "A makefile for easy project version management and continious integration.\n\n"
	@printf "Commands:\n"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "   %-14s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
ifdef DOCKER
	@printf "   %-14s %s\n" "image" "Build the docker image with a -dev suffix"
endif
	@printf "\nVariables:\n"
	@printf "   %-14s %s\n" "dry-run" "Set this variable to any value to prevent this makefile to make"
	@printf "   %-14s %s\n" "" "changes in your project"
ifdef DOCKER
	@printf "   %-14s %s\n" "no-cache" "Build the docker image without cache"
endif
	@printf $(EXTRA_HELP)
	@printf "\nAuthors:\n"
	@printf "   Fin Christensen <christensen.fin@gmail.com>\n"
	@printf "\nbaukolonne makefile - Copyright (c) 2019  Embedded Enterprises\n"

.DEFAULT_GOAL := help

PROJECT := $(call language-project-name)
VERSION := $(call language-project-version)

ifneq (,$(wildcard ./config.mk))
#~ no-inline
include config.mk
export $(shell sed 's/=.*//' config.mk)
endif

$(call check-update)
$(call semver-parse,$(VERSION))

major: ## Increment the major version number of this project
	$(call language-pre-increment)
	$(call semver-inc-major)
	$(call language-apply-version,$(call semver-fmt))
	$(call git-commit)
	$(call git-create-tag,v$(call semver-fmt))

minor: ## Increment the minor version number of this project
	$(call language-pre-increment)
	$(call semver-inc-minor)
	$(call language-apply-version,$(call semver-fmt))
	$(call git-commit)
	$(call git-create-tag,v$(call semver-fmt))

patch: ## Increment the patch version number of this project
	$(call language-pre-increment)
	$(call semver-inc-patch)
	$(call language-apply-version,$(call semver-fmt))
	$(call git-commit)
	$(call git-create-tag,v$(call semver-fmt))

release: ## Release the current version by pushing all tags to the git remote
	$(call git-is-clean)
	$(call git-push-tags)

ifdef DOCKER
image:
	$(call docker-image)
endif

build: ## (only in CI) Build this project
	$(call is-ci)
	$(call language-build)

test: ## (only in CI) Run tests for this project
	$(call is-ci)
	$(call language-test)

package: ## (only in CI) Package this project for distribution
	$(call is-ci)
	$(call language-package)

publish: ## (only in CI) Publish distribution artifacts to registries
	$(call is-ci)
	$(call language-publish)
ifdef DOCKER
	$(call docker-publish)
endif
