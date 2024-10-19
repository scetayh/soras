#!/bin/bash

#. soras 1

function _setVarSum () {
    declare -g "$1"__s="$2";
    return 0;
}

function _setVarType () {
    declare -g "$1"__t="$2";
    return 0;
}