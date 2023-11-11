#!/bin/bash

./link-package.sh browser 1.0.2
./link-package.sh bytes 1.0.8
./link-package.sh core 1.0.5
./link-package.sh file 1.0.5
./link-package.sh http 2.0.0
./link-package.sh json 1.1.3
./link-package.sh parser 1.1.0
./link-package.sh project-metadata-utils 1.0.2
./link-package.sh random 1.0.0
./link-package.sh time 1.0.0

rm -rf ./elm-tests/elm-stuff
rm -rf ./js-tests/elm-stuff
