# README

This repository contains a test suite for patches that the [elm-janitor](https://github.com/elm-janitor) packages stack on top of the official Elm core packages.

It is also useful to develop or evaluate patches to core Elm packages and their kernel code.

Every forked core package from elm-janitor is a git submodule, so best clone
this repository with `--recurse-submodules`.

Usually, you would [apply all patches](#download-and-apply-patches) and then
[run the test suites](#test-suites).

After that, you can either verify new patches, or work on your own changes.

## Download and apply patches

First, you should set the `$ELM_HOME` environment variable

```sh
# fish
set ELM_HOME (pwd)/elm-home
# sh
ELM_HOME=`pwd`/elm-home
# Windows CMD.exe
set ELM_HOME=%cd%\elm-home
```

If you use [direnv](https://direnv.net/), you can run `direnv allow` to set it to `./elm-home`.

Then you can either

**1) Use the git submodules**\
and run `./link-all-packages.sh`.\
Note: If you cloned this repository without checking out the submodules, you
can do that by running `git submodule update --init --recursive`

**2) Or use the**
[elm-janitor/apply-patches script](https://github.com/elm-janitor/apply-patches)\
to apply all the patches

```sh
# With deno
❯ deno run --allow-env=ELM_HOME,HOME --allow-read --allow-write --allow-net=github.com,codeload.github.com,api.github.com  https://raw.githubusercontent.com/elm-janitor/apply-patches/main/deno/cli.ts --all

# Or with node.js
❯ npx elm-janitor-apply-patches --all
```

After that, you can proceed to run the test suites.

## Test suites

1. Tests that only need an Elm test runner,
   see[`./elm-tests/`](./elm-tests/README.md)
2. Tests that need a fake browser environment, see
   [`./js-tests`](./js-tests/README.md)
3. Tests that need an actual browser, see
   [`./browser-tests`](./browser-tests/README.md)

## Scripts

To add a new package as a git submodule into `./package/` and link it into the
`./elm-home/0.19.1/packages/elm/<package>/<version>` directory, execute

```sh
./add-package.sh core 1.0.5
```

If you only want to update the link from `./package/<package>` to
`./elm-home/0.19.1/packages/elm/<package>/<version>`, execute

```sh
./link-package.sh core 1.0.5
```

After running tests, the git submodules might be marked as dirty. This can be
usually fixed by removing files that the Elm compiler generates on every run
with

```sh
./clean-git-submodules.sh
```

If you want to test or create pull requests for the Elm core packages, you can
add the original repositories as remote `upstream` to every git submodule by
executing

```sh
./add-upstream-git-remotes.sh
```

## Usage and development hints

### Switching between multiple versions fast

If you want to toggle between versions of a package, you can do the following:

```sh
# Remove `elm/core` from ./elm-home and let the Elm compiler install the latest version
./remove-cached-package.sh http
# Verify that the tests for elm/http fail using the upstream version
npx jest tests/http-*
# And then use the latest state of the submodule packages/http as elm/http v2.0.0
./link-package.sh http 2.0.0
```

### Compiler errors inside the js kernel code

If you make changes to the core packages and use them inside another project
(or in these tests), you won't see nice error messages, but instead get a very
generic `PROBLEM BUILDING DEPENDENCIES` error.

Then it can be helpful to run the Elm compiler on the changed Elm source file,
e.g. `cd packages/core && elm make --output=/dev/null src/Char.elm` (see for
instance
[in this issue](https://github.com/elm-janitor/apply-patches/issues/1#issuecomment-1557515507)).

If you change the js kernel code, you are completely on your own and will have
to step through the generated js code to find issues.

## Verified fixes

This repository can verify that the following issues are solved by
[elm-janitor](https://github.com/elm-janitor) patches.

- From https://github.com/elm-janitor/browser/tree/stack-1.0.2 (commit
  [53e3caa](https://github.com/elm-janitor/browser/commit/53e3caa265fd9da3ec9880d47bb95eed6fe24ee6))
  - No fixes
- From https://github.com/elm-janitor/bytes/tree/stack-1.0.8 (commit
  [2bce2ae](https://github.com/elm-janitor/bytes/commit/2bce2aeda4ef18c3dcccd84084647d22a7af36a6))
  - No fixes
- From https://github.com/elm-janitor/core/tree/stack-1.0.5 (commit
  [0d928a1](https://github.com/elm-janitor/core/commit/0d928a177fc492e32a2f9bd92f5bcf9f5ca2f68c))
  - Fixes https://github.com/elm/core/issues/942
  - Fixes https://github.com/elm/bytes/issues/15
  - Fixes https://github.com/elm/core/pull/952
- From https://github.com/elm-janitor/file/tree/stack-1.0.5 (commit
  [7c7db2c](https://github.com/elm-janitor/file/commit/7c7db2c7d60edc79791852e72f01ca227f58f9ea))
  - Fixes https://github.com/elm/file/issues/17 (bug in iOS <= 13)
- From https://github.com/elm-janitor/http/tree/stack-2.0.0 (commit
  [e065c97](https://github.com/elm-janitor/http/commit/e065c97fbbe402ac7acc249edb4061f68bd220c0))
  - Fixes https://github.com/elm/http/pull/66
- From https://github.com/elm-janitor/json/tree/stack-1.1.3 (commit
  [24a7c9a](https://github.com/elm-janitor/json/commit/24a7c9a234350366a5672e46dd135a09e0336e28))
  - TODO https://github.com/elm/json/pull/9
  - TODO https://github.com/elm/json/pull/22
  - Fixes https://github.com/elm/core/issues/904
  - Fixes https://github.com/elm/json/issues/13
  - Fixes https://github.com/elm/json/issues/15
- From https://github.com/elm-janitor/parser/tree/stack-1.1.0 (commit
  [a61f4ae](https://github.com/elm-janitor/parser/commit/a61f4ae6d789f7dd6de51a1bd67c459bce9a7a0c))
  - Fixes https://github.com/elm/parser/issues/2
  - Fixes https://github.com/elm/parser/issues/9
  - Fixes https://github.com/elm/parser/issues/20
  - Fixes https://github.com/elm/parser/issues/46
  - Fixes https://github.com/elm/parser/issues/53
- From https://github.com/elm-janitor/project-metadata-utils/tree/stack-1.0.2
  (commit
  [5fb7e5a](https://github.com/elm-janitor/project-metadata-utils/commit/5fb7e5a54ece08edb3a31f26ed91c9dd43ad5664))
  - Fixes https://github.com/elm/project-metadata-utils/pull/19
- From https://github.com/elm-janitor/random/tree/stack-1.0.0 (commit
  [1cf1144](https://github.com/elm-janitor/random/commit/1cf11440beccc83184879eea9b233758355a6ef2))
  - Fixes https://github.com/elm/random/issues/21
  - Fixes https://github.com/elm/random/pull/22
- From https://github.com/elm-janitor/time/tree/stack-1.0.0 (commit
  [7b97ef5](https://github.com/elm-janitor/time/commit/7b97ef513b289d7b88704fcfc5a0807f7eb4f5ce))
  - No fixes
- From https://github.com/elm-janitor/virtual-dom/tree/stack-1.0.3 (commit
  [962f555](https://github.com/elm-janitor/virtual-dom/commit/962f55501704292d8b2b66695fc1f587b5185ef7))
  - No fixes
