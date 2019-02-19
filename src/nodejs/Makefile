define language-project-name
$(shell sed -rn 's/^\s+"name":\s+"(@\w+\/)?(.*)".*$$/\2/p' package.json)
endef

define language-project-version
$(shell sed -rn 's/^\s+"version":\s+"(.*)".*$$/\1/p' package.json)
endef

define language-pre-increment
$(call say,Linting project...)
@npm run lint
$(call section)
$(call say,Running tests in project...)
@npm run test
endef

define language-apply-version
$(call say,Setting new version $(1) for project $(PROJECT)...)
$(if $(dry-run),,@sed -ri 's/("?version"?:.*)$(SEMVER_REGEX)/\1$(1)/i' \
	package.json \
	src/environments/environment.ts \
	src/environments/environment.prod.ts)
endef

define language-build
@npm ci
@npm run build
$(call section)
$(call artifacts,dist/*)
endef

define language-test
@npm ci
@npm run lint
@npm run test
endef

define language-package
@npm ci
@npm pack --unsafe-perm
$(call section)
$(call artifacts,*.tgz)
endef

define language-publish
@npm ci
@npm publish --unsafe-perm
endef

include ../main.mk
