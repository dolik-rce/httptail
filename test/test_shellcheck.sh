#!/bin/bash

# shellcheck source=test/setup.sh
. "$(dirname "$0")/setup.sh"

FILES=( httptail httptailrc test/*.sh )

plan tests "${#FILES[@]}"

# musíme nastavit locale, jinak si shellcheck neporadí s utf-8
export LANG="cs_CZ.utf-8"
export LC_ALL=""

OUTPUT="$(shellcheck --exclude=SC2034 --format gcc -s bash "${FILES[@]}" 2>&1)"

for F in "${FILES[@]}"; do
    if grep -qF "$F:" <<<"$OUTPUT"; then
        diag "$(grep -F "$F:" <<<"$OUTPUT")"
        fail "Shellcheck for $F"
    else
        pass "Shellcheck for $F"
    fi
done
