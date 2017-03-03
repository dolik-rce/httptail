#!/bin/bash

# shellcheck source=test/setup.sh
. "$(dirname "$0")/setup.sh"

plan tests 2

cat > "$TMP/follow" <<EOF
abcde
fghij
EOF

start() {
    "$ROOTDIR"/httptail --config "/dev/null" --interval 0.1 --follow "$SERVER/follow" > "$TMP/out" &
    KILLCMD="kill $!"
    TRAPCMD="$KILLCMD; $TRAPCMD"
}

end() {
    eval "$KILLCMD"
    KILLCMD=":"
}

start
sleep 0.2
is "$(< "$TMP/out")" "$(< "$TMP/follow")" "initial data loaded correctly"
{ echo "more"; echo "even more"; } >> "$TMP/follow"
sleep 0.2
is "$(< "$TMP/out")" "$(< "$TMP/follow")" "more data loaded correctly"
end
