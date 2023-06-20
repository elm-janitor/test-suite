# README for tests that need an actual browser

The tests in this directory are usually slower to execute than the ones in `../elm-tests/` and `../js-tests`.  
They use [playwright]()

## Installation

```sh
npm install
npx elm-tooling-cli install
```

## Run tests

Run the test suite with

```sh
npx playwright test
```
