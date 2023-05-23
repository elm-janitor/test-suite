# README

This repository is useful to develop and verify fixes to core Elm packages.  

Usually, you would [apply all patches](#download-and-apply-patches) and then [run the test suites](#test-suites).

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

Then you can either 

**1) Use the git submodules**  
by clone all of them to your disk and then run `./link-all-packages.sh`

**2) Use the** [elm-janitor/apply-patches script](https://github.com/elm-janitor/apply-patches)  
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
see [`./elm-tests/`](./elm-tests/README.md)
2. Tests that need a fake browser environment,
TODO look into e.g. [JSDOM](https://github.com/jsdom/jsdom) or [HappyDOM](https://github.com/capricorn86/happy-dom)
3. Tests that need an actual browser,
TODO use [playwright](https://playwright.dev/)

## Scripts

To add a new package as a git submodule into `./package/` and link it into the `./elm-home/0.19.1/packages/elm/<package>/<version>` directory, execute

```sh
./add-package.sh core 1.0.5
```

If you only want to update the link from `./package/<package>` to `./elm-home/0.19.1/packages/elm/<package>/<version>`, execute

```sh
./link-package.sh core 1.0.5
```

After running tests, the git submodules might be marked as dirty. This can be usually fixed by removing files that the Elm compiler generates on every run with

```sh
./clean-git-submodules.sh
```
