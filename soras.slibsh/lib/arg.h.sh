#!/usr/bin/env bash

source log.h.sh
source cmdinfo.h.sh
source var.h.sh

log_error_parse_argument() {
    log error "failed to parse argument"
}

#@ flag <short name> <long name>
flag() {
    append opt_short $1
    append opt_long ,$2
}

#@ option <short name> <long name>
option() {
    append opt_short $1
    append opt_long ,$2
}

#@ operand { <number> | @ }
operand() {
    operand=
}