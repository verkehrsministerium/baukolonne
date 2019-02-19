# GIT
#
# The git module contains macros for easy interaction with git.
#
# `git-is-clean` check if there are any uncommitted changes in the source
# repository.
#
# `git-commit` adds and commits all changed files in the repository.
#
# `git-create-tag` creates a tag in the git repository. This is used to tag
# a version in the source repository.
#
# `git-push-tags` pushes all tags of the local repository to the remote.

define git-is-root
$(shell test -d .git && echo 1)
endef

ifeq ($(call git-is-root),)
$(shell echo -e "\e[1mThe current folder is not a git root directory! Omitting repository actions...\e[0m" 1>&2)
endif

define git-is-clean
$(if $(git-is-root),
	$(call say,Checking for uncommitted changes in git...)
	@test -z "$(shell git status -s)"
)
endef

define git-commit
$(if $(git-is-root),
	$(call section)
	$(call say,Commiting changes in git repository...)
	$(if $(dry-run),,@git add -A && git commit -S)
)
endef

define git-create-tag
$(if $(git-is-root),
	$(call say,Creating tag $(1) in git repository...)
	$(if $(dry-run),,@git tag -s -m "Update version" "$(1)")
)
endef

define git-push-tags
$(if $(git-is-root),
	$(call say,Pushing tags to git remote...)
	$(if $(dry-run),,@git push)
	$(if $(dry-run),,@git push --tags)
)
endef
