#!/bin/bash

# shellcheck source=test/setup.sh
. "$(dirname "$0")/setup.sh"

plan tests 12

cat > "$TMP/data" <<EOF
123456789
123456789
123456789
123456789
EOF

param_test() {
    EXP="$1"
    shift
    "$ROOTDIR"/httptail --config "/dev/null" "$@" "$SERVER/data" > "$TMP/out"
    ok $? "${*:-without parameters} works"
    is "$(< "$TMP/out")" "$EXP" "${*:-without parameters} downloads correct data"
}

param_test "$(cat "$TMP/data"; echo)"
param_test "$(tail -c 20 "$TMP/data"; echo)" --count 20
param_test "$(tail -c 30 "$TMP/data"; echo)" --start 10
param_test "$(tail -c 10 "$TMP/data"; echo)" --end 10
param_test "$(tail -c 25 "$TMP/data" | head -c 15; echo)" --start 15 --end 10
param_test "$(sed "s|^|$SERVER/data: |" "$TMP/data"; echo)" --prepend
