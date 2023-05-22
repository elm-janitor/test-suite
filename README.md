# README

## Scripts

To add a new package as a git submodule into `./package/` and link it into the `./elm-home/0.19.1/packages/elm/<package>/<version>` directory, execute

```sh
./add-package.sh core 1.0.5
```

If you only want to update the link from `./package/<package>` to `./elm-home/0.19.1/packages/elm/<package>/<version>`, execute

```sh
./link-package.sh core 1.0.5
```
