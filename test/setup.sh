#!/bin/bash

ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && echo "$PWD")"
BASHLIB="$(find "$ROOTDIR/test/test-more-bash" -type d \( -name bin -o -name lib \) -print0 | xargs -r0 printf "%s:")"
PATH="$BASHLIB$PATH"

# shellcheck disable=SC1091
. bash+ :std

use Test::More

if [ -z "$SERVER" ]; then
    TMP="$ROOTDIR/.test_tmp"
    rm -rf "$TMP"
    mkdir -p "$TMP"
    cd "$TMP" || exit 1
    PYTHON2="$(type -Pf python python2 | tail -n 1)"
    PYTHONPATH="$ROOTDIR/test/rangehttpserver" "$PYTHON2" -m RangeHTTPServer 24680 &>/dev/null &
    SERVERPID=$!
    until netstat -ntl | grep -q '24680'; do sleep 0.1; done
    TRAPCMD="kill $SERVERPID; rm -rf '$TMP'"
    trap 'eval "$TRAPCMD"' EXIT
    SERVER="http://localhost:24680"
fi

cd "$ROOTDIR" || exit 1
set +e
