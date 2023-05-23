# README for elm-only tests

The tests inside this directory don't need a browser environment, and can be
verified using [elm-test-rs](https://github.com/mpizenberg/elm-test-rs) or
[elm-test](https://github.com/rtfeldman/node-test-runner).

## Installation

```sh
npm install
npx elm-tooling-cli install
```

## Run tests

Run the test suite with

```sh
npx elm-test-rs tests
```
