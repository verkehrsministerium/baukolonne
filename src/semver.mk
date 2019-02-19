# SEMVER
#
# The semver module contains macros for easy editing of semantic version strings
#
# Parse a version string with `semver-parse` like this:
#
# ```make
# $(call semver-parse,0.7.6-alpha)
# ```
#
# After parsing the string you can use `semver-inc-patch`, `semver-inc-minor`,
# and `semver-inc-major` to increment the version.
#
# To print the new version number use this:
#
# ```make
# @echo New version is $(call semver-fmt)
# ```

SEMVER_REGEX := ([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+)(-(.*))?

define semver-parse
$(eval
	SEMVER := $(shell
		echo $(1) | sed -rn 's/$(SEMVER_REGEX)/\1 \2 \3 \5/p'))
endef

define semver-inc-patch
$(eval
	SEMVER := \
		$(word 1,$(SEMVER)) \
		$(word 2,$(SEMVER)) \
		$(shell echo $$(($(word 3,$(SEMVER))+1))) \
		$(word 4,$(SEMVER)))
endef

define semver-inc-minor
$(eval
	SEMVER := \
		$(word 1,$(SEMVER)) \
		$(shell echo $$(($(word 2,$(SEMVER))+1))) \
		0 \
		$(word 4,$(SEMVER)))
endef

define semver-inc-major
$(eval
	SEMVER := \
		$(shell echo $$(($(word 1,$(SEMVER))+1))) \
		0 \
		0 \
		$(word 4,$(SEMVER)))
endef

define semver-fmt
$(shell
	echo -n $(word 1,$(SEMVER)).$(word 2,$(SEMVER)).$(word 3,$(SEMVER)) && \
	[ $(words $(SEMVER)) -ge 4 ] \
		&& echo -$(word 4,$(SEMVER))
		|| echo)
endef
