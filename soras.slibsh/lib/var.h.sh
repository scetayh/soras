#!/usr/bin/env bash

append() {
    local var=$1
    shift
    eval $var=\"\$\{$var\}\$\*\"
}