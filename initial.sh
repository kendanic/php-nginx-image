#!/usr/bin/env bash

# Create /.composer folder (if needed)
mkdir -p /.composer
chmod -R ugo+rw /.composer

# Run any passed command or start supervisor
if [ "$#" -gt 0 ]; then
    exec "$@"
else
    exec /usr/bin/supervisord
fi
