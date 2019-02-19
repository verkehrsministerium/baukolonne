# CORE
#
# The core module implements basic macros of the robulab Makefile.
#
# `say` prints an informational message to the console.
#
# `section` prints an empty line to mark the beginning of a new section.
#
# `check-update` checks for updates for this Makefile and installs the update
# if available.
#
# `is-ci` checks whether this Makefile is running in a continious integration
# setup and asks to continue if this is not the case.
#
# `artifacts` takes a list of artifacts that will be stored by the continious
# integration and calculates sha256 sums for each of the artifacts.

ifneq ("$(wildcard /bin/bash)","")
SHELL=/bin/bash
else
SHELL=/bin/sh
$(shell echo -e "\e[33;1mWarning!\e[0;1m No /bin/bash available! Using /bin/sh instead...\e[0m" 1>&2)
endif

define say
@echo -e "\e[1m$(1)\e[0m"
endef

define section
@echo
endef

define get-latest-version
$(shell echo 0.0.0)
endef

define check-update
$(shell test -n "$$CI" || ( test $$(echo -e \
		"$(call get-latest-version)\n$(MAKEFILE_VERSION)" | sort -r | head -n 1 \
	) != "$(MAKEFILE_VERSION)" && ( \
		echo -ne "\e[1mAn update for this Makefile is available! Install? (y/n) \e[0m" 1>&2 && \
		read -r -n 1 && \
		echo 1>&2 && \
		[[ "$$REPLY" =~ ^[Yy]$$ ]] && \
		echo Not implemented yet 1>&2 \
	)))
endef

define is-ci
@test -n "$$CI" || ( \
	echo -ne "\e[1mThis target is only supported to run in a CI environment! Run anyway? (y/n) \e[0m" && \
	read -r -n 1 && \
	echo && \
	[[ "$$REPLY" =~ ^[Yy]$$ ]] )
endef

define artifacts
$(call say,Generating sha256 checksums for artifacts...)
@test -z "$(1)" || sha256sum $$(printf "%s\n" $(1) | while read -r file; do find "$$file" -type f; done | xargs)
endef
