#!/bin/bash

#. soras 1

#. include {
. include _shvar/get.lib.sh;
. include _shvar/set.lib.sh;
. include _shvar/unset.lib.sh;
#. }

function _isType () {
    if [ "$(_getVarType $1)" = "$2" ]; then {
        return 0;
    }
    else {
        return 1;
    }
    fi;
}

function _isNotDeclared () {
    _isType "$1" "";
}