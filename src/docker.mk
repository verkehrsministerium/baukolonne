# DOCKER
#
# The docker helps with building and publishing docker images.
#
# `docker-build` builds a development version of the docker image.
#
# `docker-publish` builds a production version of the docker image
# and publishes version and latest tagged images to the docker registry.

ifneq (,$(wildcard ./Dockerfile))
$(eval DOCKER := 1)
endif

DOCKER_REPO ?=

ifdef DOCKER_REPO
DOCKER_NAME := $(PROJECT)
else
DOCKER_NAME := $(DOCKER_REPO)/$(PROJECT)
endif

define docker-build
@docker build $(if $(no-cache),--no-cache) \
	--build-arg APP_NAME="$(PROJECT)" \
	--build-arg APP_VERSION="$(call semver-fmt)" \
	--build-arg NPM_AUTH_TOKEN="$(NPM_AUTH_TOKEN)" \
	-t "$(1):latest" .
@test -z "$(2)" && docker tag "$(1):latest" "$(1):$(call semver-fmt)" || true
endef

define docker-publish
$(call say,Building production docker image for $(PROJECT)...)
$(call docker-build,$(DOCKER_NAME))
$(call section)
$(call say,Pushing :$(call semver-fmt) and :latest tagged images to registry...)
$(if $(dry-run),,@echo docker push "$(DOCKER_NAME):$(call semver-fmt)")
$(if $(dry-run),,@echo docker push "$(DOCKER_NAME):latest")
endef

define docker-image
$(call say,Building docker image for $(PROJECT)...)
$(call docker-build,$(PROJECT)-dev)
$(call section)
$(call say,To run this docker image do:)
@echo docker run -it --rm "$(PROJECT)-dev"
endef
