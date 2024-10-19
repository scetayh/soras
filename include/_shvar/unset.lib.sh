#!/bin/bash

#. soras 1

function _unsetVarSum () {
    unset "$1"__s;
    return 0;
}

function _unsetVarType () {
    unset "$1"__t;
    return 0;
}