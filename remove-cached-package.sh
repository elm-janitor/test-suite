#!/bin/bash

PKG=$1

if [ -z "$PKG" ]; 
    then echo "Error: You need to pass a package name"
    echo ""
    echo "Usage:"
    echo "./`basename $0` <package name> <version number>"
    exit 1
fi

ELM_CACHE_DIR=`pwd`/elm-home/0.19.1/packages/elm
DIR=$ELM_CACHE_DIR/$PKG
rm -rf "$DIR"
echo "Removed $DIR"

rm -rf ./elm-tests/elm-stuff
