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
param_test "$(dd if="$TMP/data" bs=1 count=11 2> /dev/null; echo)" --end 10
param_test "$(dd if="$TMP/data" bs=1 skip=15 count=11 2> /dev/null; echo)" --start 15 --end 25
param_test "$(sed "s|^|$SERVER/data: |" "$TMP/data"; echo)" --prepend
