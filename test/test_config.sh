#!/bin/bash

# shellcheck source=test/setup.sh
. "$(dirname "$0")/setup.sh"

plan tests 22

cat > "$TMP/conf" <<EOF
INTERVAL=4
COUNT=1234
PROXY=proxy:3128
OPTS=("-k")
USER=jack
PASSWORD="secret"

preset p
    INTERVAL=8
    COUNT=4321
    PROXY=""
    OPTS=("-opt")
    FILE="filename"
    SERVERS=("1.example.com" "2.example.com")
    USER=jimmy
    PASSWORD="ASK"

preset q
    INTERVAL=16

EOF

sed '/main "\$@"/d;' "./httptail" > "$TMP/patched_httptail"

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
test_variable "GLOBAL_SERVERS[*]" ""

test_variable "PRESET_INTERVAL" ""
test_variable "PRESET_COUNT" ""
test_variable "PRESET_PROXY" ""
test_variable "PRESET_OPTS[*]" ""
test_variable "PRESET_FILE" ""
test_variable "PRESET_SERVERS[*]" ""

test_variable "INTERVAL" "4"
test_variable "COUNT" "1234"
test_variable "PROXY" "proxy:3128"
test_variable "http_proxy" "proxy:3128"
test_variable "https_proxy" "proxy:3128"
test_variable "USER" "jack"
test_variable "PASSWORD" "secret"
test_variable "OPTS[*]" '-k --config /dev/fd/9'
test_variable "FILE" ""
test_variable "SERVERS[*]" ""
