define language-project-name
@true
endef

define language-project-version
@true
endef

define language-pre-increment
$(call docker-build,$(PROJECT)-dev,no)
endef

define language-apply-version
$(call say,Setting new version $(1) for project $(PROJECT)...)
$(if $(dry-run),,@sed -ri 's/(VERSION=.*)$(SEMVER_REGEX)/\1$(1)/' config.mk)
endef

define language-build
$(call say,Building production docker image for $(PROJECT)...)
$(call docker-build,$(DOCKER_NAME))
endef

define language-test
@true
endef

define language-package
@true
endef

define language-publish
$(call docker-publish)
endef

include ../main.mk
