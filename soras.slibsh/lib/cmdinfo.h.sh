#!/usr/bin/env bash

source log.h.sh

#@ has_cmd <command>
has_cmd() {
    command -v -- "$1" &> /dev/null || \
        return 1
}

#@ check_cmds_existence <command>...
check_cmd() {
    for cmd in "$@"; do
        ! has_cmd "$cmd" || \
            log error "command '$cmd' not found"
    done
}