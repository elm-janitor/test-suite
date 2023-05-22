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

ELM_CACHE_DIR=`pwd`/elm-home/0.19.1/packages/elm

# ensure base directory exists
mkdir -p $ELM_CACHE_DIR/$PKG
FROM=`pwd`/packages/${PKG}
TO=$ELM_CACHE_DIR/${PKG}/${VERSION}
# remove possibly existing link
rm -rf ${TO}
# add link
ln -s  ${FROM} ${TO}
echo "Linked $FROM to $TO"

# remove cache directory
rm -rf ./elm-tests/elm-stuff
