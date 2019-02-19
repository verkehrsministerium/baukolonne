include src/core.mk
include src/semver.mk
include src/git.mk

define language-apply-version
$(call say,Setting new version $(1) for project $(PROJECT)...)
$(if $(dry-run),,@sed -ri 's/(VERSION := )$(SEMVER_REGEX)/\1$(1)/' Makefile)
endef

.PHONY: help major minor patch release build package

help: ## Display this help message
	@printf "Usage: make [var=value] [commands...]\n\n"
	@printf "Build and package the baukolonne makefiles.\n\n"
	@printf "Commands:\n"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "   %-10s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@printf "\nVariables:\n"
	@printf "   %-10s %s\n" "dry-run" "Set this variable to any value to prevent this makefile to make"
	@printf "   %-10s %s\n" "" "changes in your project"
	@printf "\nAuthors:\n"
	@printf "   Fin Christensen <christensen.fin@gmail.com>\n"
	@printf "\nbaukolonne makefile - Copyright (c) 2019  Embedded Enterprises\n"

.DEFAULT_GOAL := help

PROJECT := baukolonne
VERSION := 0.1.0

$(call semver-parse,$(VERSION))

export VERSION PROJECT

major: ## Increment the major version number of this project
	$(call semver-inc-major)
	$(call language-apply-version,$(call semver-fmt))
	$(call git-commit)
	$(call git-create-tag,v$(call semver-fmt))

minor: ## Increment the minor version number of this project
	$(call semver-inc-minor)
	$(call language-apply-version,$(call semver-fmt))
	$(call git-commit)
	$(call git-create-tag,v$(call semver-fmt))

patch: ## Increment the patch version number of this project
	$(call semver-inc-patch)
	$(call language-apply-version,$(call semver-fmt))
	$(call git-commit)
	$(call git-create-tag,v$(call semver-fmt))

release: ## Release the current version by pushing all tags to the git remote
	$(call git-is-clean)
	$(call git-push-tags)

build: ## Build this project
	$(call say,Building Makefiles for each language...)
	@bash ./scripts/inline-includes.sh

test:
	$(call say,Running end2end tests for each language...)
	@npm install shellshot
	@./node_modules/.bin/jest

package: build ## Package this project for distribution
	$(call say,Packaging Makefiles for distribution...)
	@bash ./scripts/package-makefiles.sh

clean: ## Clean all package and build artifacts from project directory
	$(call say,Cleaning package and build artifacts...)
	@rm -r build package
