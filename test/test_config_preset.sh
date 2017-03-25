#!/bin/bash

# shellcheck source=test/setup.sh
. "$(dirname "$0")/setup.sh"

plan tests 22

cat > "$TMP/conf" <<EOF
INTERVAL=4
COUNT=1234
PROXY=proxy:3128
OPTS=("-k")
USER=john
PASSWORD="ASK"

preset p
    INTERVAL=8
    COUNT=4321
    PROXY=""
    OPTS=("-opt")
    FILE="filename"
    SERVERS=("1.example.com" "2.example.com")
    USER=joe
    PASSWORD="secret"

preset q
    INTERVAL=16

EOF

sed '/main "\$@"/d;' "./httptail" > "$TMP/patched_httptail"

test_variable () {
    is "${!1}" "$2" "$1 is set correctly"
}

# shellcheck source=httptail
. "$TMP/patched_httptail"

configure --config "$TMP/conf" --preset p

test_variable "GLOBAL_INTERVAL" "4"
test_variable "GLOBAL_COUNT" "1234"
test_variable "GLOBAL_PROXY" "proxy:3128"
test_variable "GLOBAL_OPTS[*]" "-k"
test_variable "GLOBAL_FILE" ""
test_variable "GLOBAL_SERVERS[*]" ""

test_variable "PRESET_INTERVAL" "8"
test_variable "PRESET_COUNT" "4321"
test_variable "PRESET_PROXY" ""
test_variable "PRESET_OPTS[*]" "-opt"
test_variable "PRESET_FILE" "filename"
test_variable "PRESET_SERVERS[*]" "1.example.com 2.example.com"

test_variable "INTERVAL" "8"
test_variable "COUNT" "4321"
test_variable "PROXY" ""
test_variable "http_proxy" ""
test_variable "https_proxy" ""
test_variable "USER" "joe"
test_variable "PASSWORD" "secret"
test_variable "OPTS[*]" '-opt --config /dev/fd/9'
test_variable "FILE" "filename"
test_variable "SERVERS[*]" "1.example.com 2.example.com"
