#!/bin/bash

#. soras 1

function _getVarSum () {
    eval echo \$'{'"$1"__s'}';
    return 0;
}

function _getVarType () {
    eval echo \$'{'"$1"__t'}';
    return 0;
}