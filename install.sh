#!/bin/bash

# Installs httptail to given directory. This script can be used for direct
# installation (if run with proper permissions) or to help while creating
# a package.
#
# Usage:
#   ./install.sh [<destdir> [prefix]]
#       where <destdir> defaults to '/'
#       and <prefix> defaults to 'usr'
#
# Examples:
#   ./install.sh
#       - installs the script to /usr/local/bin/httptail
#         and the default configuration to /etc/httptailrc
#
#   ./install.sh debian/tmp /usr/local
#       - installs the script to debian/tmp/usr/local/bin/httptail
#         and the default configuration to debian/tmp/etc/httptailrc

SRCDIR="$(dirname "${BASH_SOURCE[0]}")"
DESTDIR="${1:-/}"
PREFIX="${2:-usr}"

mkdir -p "$DESTDIR/$PREFIX/bin" "$DESTDIR/etc"
cp "$SRCDIR/httptail" "$DESTDIR/$PREFIX/bin/"
cp "$SRCDIR/httptailrc" "$DESTDIR/etc/httptailrc"
