#!/bin/sh

set -eu

if [ -f tmp/pids/server.pid ]; then
 rm tmp/pids/server.pid
fi

set -- bundle exec "$@"

echo "$@"
exec "$@"