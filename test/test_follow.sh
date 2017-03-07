#!/bin/bash

# shellcheck source=test/setup.sh
. "$(dirname "$0")/setup.sh"

plan tests 4

cat > "$TMP/follow" <<EOF
abcde
fghij
EOF

start() {
    KILLCMD="$("$ROOTDIR"/httptail --config "/dev/null" --interval 0.1 --follow "$SERVER/follow" > "$TMP/out" & echo "kill $!")"
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

cp "$TMP/out" "$TMP/expected"
echo -n > "$TMP/follow"
sleep 0.2
is "$(< "$TMP/out")" "$(< "$TMP/expected")" "truncation of followed file doesn't break anything"

echo "new content" > "$TMP/follow"
cat "$TMP/follow" >> "$TMP/expected"
sleep 0.2
is "$(< "$TMP/out")" "$(< "$TMP/expected")" "data loaded correctly after truncation"

end
