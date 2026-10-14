#!/bin/sh
set -e

# global npm tools live in the user prefix; install on first start
command -v opencode >/dev/null 2>&1 || npm install -g @opencode/cli
command -v openchamber >/dev/null 2>&1 || npm install -g @openchamber/web

exec "$@"
