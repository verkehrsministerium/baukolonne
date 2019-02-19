# Baukolonne

![](https://img.shields.io/badge/endpoint.svg?url=https://verkehrsministerium.github.io/baukolonne/debian.json)

Makefiles for easy project version management, continious integration, and project lifecycle management

Once a Makefile is installed in a project it will update itself automatically from
the CI builds of this project.

## Extend this project for new languages

Before starting with internals a quick introduction on how to produce developer builds
of the Makefiles and distribution packages that will later be stored in CI.

Use `make build` to generate one Makefile per language into the `build` folder.

To produce a distribution package type `make package`. This will generate a `tgz`
for each language under the `package` folder.

To cleanup your local workspace use `make clean`.

For version increments use the `major`, `minor`, and `patch` targets. Type `make help`
for a more detailed description.

To implement support for a new language you have to implement a number of make macros
that are specific for your language. First you should start creating a subfolder under
`src` for your language and create an empty project in this location for testing of
the Makefile. Add an empty Makefile to this folder and start implementing the following
macros for your language. Make sure that the last line of the Makefile always is the
`main.mk` include:

```make
include ../main.mk
```

### `language-project-name`

This macro prints the project name parsed from language specific configuration files
to stdout.

#### Arguments

None

#### Prints

The project name

### `language-project-version`

This macro prints the project semver string parsed from the language specific configuration
files to stdout.

#### Arguments

None

#### Prints

The semver string

### `language-pre-increment`

This macro runs before a version gets incremented and should run the linter and tests the project.

#### Arguments

None

#### Prints

Ignored

### `language-apply-version`

This macro applys a new semver version string to the language specific configuration files
of the project.

#### Arguments

1. The semver string

#### Prints

None

### `language-build`

This macro runs a language specific build command that builds the project. After building
the sha256 sum of all produced build artifacts is printed. This is done with the `artifacts`
make macro from the `core.mk`.

#### Arguments

None

#### Prints

Ignored

### `language-test`

This macro runs the linter, code formatter and all tests of the project.

#### Arguments

None

#### Prints

Ignored

### `language-package`

This macro packages the project for distribution and prints the sha256 sum
of all produced packages with the `artifacts` macro.

#### Arguments

None

#### Prints

Ignored

### `language-publish`

This macro publishes the project with the languages toolchain.

#### Arguments

None

#### Prints

Ignored
