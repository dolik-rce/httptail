#!/bin/bash

# shellcheck source=test/setup.sh
. "$(dirname "$0")/setup.sh"

plan tests 12

cat > "$TMP/data1" <<EOF
abcde
fghij
EOF

cat > "$TMP/data2" <<EOF
12345
67890
EOF

param_test() {
    EXP="$1"
    shift
    "$ROOTDIR"/httptail --config "/dev/null" "$@" "$SERVER/data"{1,2} > "$TMP/out"
    ok $? "${*:-without parameters} works"
    is "$(< "$TMP/out")" "$EXP" "${*:-without parameters} downloads correct data"
}

dup () {
    eval "cat '$TMP/data1' | $*"
    eval "cat '$TMP/data2' | $*"
    echo
}

param_test "$(dup "cat")"
param_test "$(dup "tail -c 8")" --count 8
param_test "$(dup "tail -c 8")" --start 4
param_test "$(dup "tail -c 10")" --end 10
param_test "$(dup "tail -c 8 | head -c 4")" --start 4 --end 4
param_test "$(grep -e ... "$TMP"/data{1,2} | sed "s|:|: |;s|$TMP|$SERVER|;")" --prepend
