#! /bin/bash

#git fetch origin && git reset --hard origin/master && git clean -f -d
git fetch origin && git reset --hard origin/dev && git clean -f -d

python -m compileall .
# Set permissions
chmod -R 744 *
