#!/bin/bash

PKG=$1
VERSION=$2

if [ -z "$PKG" ]; then echo "Error: You need to pass a package name"; fi
if [ -z "$VERSION" ]; then echo "Error: You need to pass a version number"; fi
if [ -z "$PKG" ] || [ -z "$VERSION" ]; then
    echo ""
    echo "Usage:"
    echo "./`basename $0` <package name> <version number>"
    exit 1
fi

# Clone it as a submodule, and use the `stack-<version>` branch that is intended for distribution
git submodule add --branch stack-$VERSION git@github.com:elm-janitor/$PKG.git packages/$PKG

echo "Executing ./link-package.sh $PKG $VERSION"
./link-package.sh "$PKG" "$VERSION"
