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

function _isDeclared () {
    ! _isNotDeclared "$1";
}

function _isInt () {
    _isType "$1" int;
}

function _isFloat () {
    _isType "$1" float;
}

function _isStr () {
    _isType "$1" str;
}

function _isBool () {
    _isType "$1" bool;
}