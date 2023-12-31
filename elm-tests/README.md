# README for elm-only tests

The tests inside this directory don't need a browser environment, and can be
verified using [elm-test-rs](https://github.com/mpizenberg/elm-test-rs) or
[elm-test](https://github.com/rtfeldman/node-test-runner).

## Installation

```sh
npm install
npx elm-tooling install
```

## Run tests

Run the test suite with

```sh
npx elm-test-rs
```

## Adding tests

To generate a test file for an issue or pull request, you can run 

```sh
./add-pr.sh <pkg> <number>
```
