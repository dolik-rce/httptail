#!/bin/bash

# shellcheck source=test/setup.sh
. "$(dirname "$0")/setup.sh"

plan tests 10

cat > "$TMP/data" <<EOF
123456789
123456789
123456789
123456789
EOF

cat > "$TMP/conf" <<EOF
INTERVAL=4
COUNT=1234
PROXY=proxy:3128
OPTS=("-k")
USER=jill
PASSWORD="ASK"

EOF

sed 's/read .* PASSWORD/& <<<"P4SSW0RD"/;' "./httptail" > "$TMP/patched_httptail"

bash "$TMP/patched_httptail" --config "$TMP/conf" -x "$SERVER/data" &> "$TMP/out"
is "$(grep "P4SSW0RD" "$TMP/out")" "" "Debug output does not show password"

sed '/main "\$@"/d;' -i "$TMP/patched_httptail"

test_variable () {
    is "${!1}" "$2" "$1 is set correctly"
}

# shellcheck source=httptail
. "$TMP/patched_httptail"

configure --config "$TMP/conf"

test_variable "GLOBAL_INTERVAL" "4"
test_variable "GLOBAL_COUNT" "1234"
test_variable "GLOBAL_PROXY" "proxy:3128"
test_variable "GLOBAL_OPTS[*]" "-k"
test_variable "GLOBAL_FILE" ""
test_variable "GLOBAL_PASSWORD" "ASK"
test_variable "GLOBAL_SERVERS[*]" ""

test_variable "PASSWORD" "P4SSW0RD"
test_variable "OPTS[*]" '-k --config /dev/fd/9'

