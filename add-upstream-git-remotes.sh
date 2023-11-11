#!/bin/bash

echo "Add git remote \`upstream\` where needed"

cd packages/

for repo in *; do
    if [ -d "$repo" ]; then
        echo;
        echo "Checking package $repo"
        cd $repo
        desired="git@github.com:elm/$repo.git"
        upstream=$(git remote get-url upstream)
        if [ -z "$upstream" ]; then
            echo "Will set upstream to $desired"
            git remote add upstream "$desired"
        else
            echo "upstream was already set to $upstream"
        fi
        git fetch upstream
        cd ..
    fi
done

cd ..
