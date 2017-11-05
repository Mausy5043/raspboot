#! /bin/bash

# update.sh
# force a synchronisation with the current state on the GitHub server

ME=$(whoami)

branch=$(cat $HOME/.raspboot.branch)
git pull
git fetch origin
git checkout $branch && git reset --hard origin/$branch && git clean -f -d

# Set permissions
chmod -R 744 *
