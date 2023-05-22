#!/bin/bash

PKG=$1
PR=$2

if [ -z "$PKG" ]; then echo "Error: You need to pass a package name"; fi
if [ -z "$PR" ]; then echo "Error: You need to pass a PR number"; fi
if [ -z "$PKG" ] || [ -z "$PR" ]; then
    echo ""
    echo "Usage:"
    echo "./`basename $0` <package name> <PR number>"
    exit 1
fi

MODULE_NAME="${PKG^}"
FILE=tests/$MODULE_NAME/PR$PR.elm

cat > $FILE <<EOF
module $MODULE_NAME.PR$PR exposing (suite)

{-| Test changes of <https://github.com/elm/$PKG/pull/$PR>
-}

import Expect
import Test exposing (..)
import $MODULE_NAME exposing ($MODULE_NAME)


suite : Test
suite =
    describe "Fixes from https://github.com/elm/$PKG/pull/$PR"
        [ examplePr$PR
        , issue$PR
        ]


{-| from <https://github.com/elm/$PKG/pull/$PR>
-}
examplePr$PR : Test
examplePr$PR =
    todo "Example https://github.com/elm/$PKG/pull/$PR"


{-| Fixes <https://github.com/elm/$PKG/issues/$PR>
-}
issue$PR : Test
issue$PR =
    todo "Fix https://github.com/elm/$PKG/issues/$PR"
EOF

echo "Created new test file $FILE"
