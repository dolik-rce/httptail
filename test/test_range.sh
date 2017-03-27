#!/bin/bash

# shellcheck source=test/setup.sh
. "$(dirname "$0")/setup.sh"

plan tests 10

sed '/main "\$@"/d;' "./httptail" > "$TMP/patched_httptail"

test_range () {
    local EXPECTED="$1"
    shift
    unset -v start
    unset -v end
    unset -v count
    parse_args "$@"
    calculate_range
    is "$range" "$EXPECTED" "Range for '$*' is calculated correctly"
}

# shellcheck source=httptail
. "$TMP/patched_httptail"
DEFAULT_COUNT=4096

get_length() {
    echo 100
}

test_range "-4096"

test_range "20-" --start 20
test_range "0-30" --end 30
test_range "-40" --count 40

test_range "20-30" --start 20 --end 30
test_range "0-30" --count 40 --end 30
test_range "31-60" --count 30 --end 60
test_range "20-60" --start 20 --count 40

test_range "20-30" --start 20 --end 30 --count 40
test_range "41-80" --start 20 --end 80 --count 40
