# README for tests that need an actual browser

The tests in this directory are usually slower to execute than the ones in `../elm-tests/` and `../js-tests`.  
They use [playwright](https://playwright.dev/) so you can run them in Firefox, Chrome/ium or Webkit (without Safari branding).

## Installation

```sh
npm install
npx elm-tooling install
```

## Run tests

Run the test suite with

```sh
npx playwright test
```

Note: The `elm-stuff` directories are removed on every test run, see `./tests/shared.ts` so you should not get stale dependencies.
