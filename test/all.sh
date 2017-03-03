#!/bin/bash

prove -v "$(dirname "${BASH_SOURCE[0]}")"/test_*.sh
