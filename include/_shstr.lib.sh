#!/bin/bash

#. soras 1

function _getShstrByFigure () {
    echo "${1: $2: 1}";
}

function _isStartingWith () {
    [ "$(_getShstrByFigure "$1" 0)" = "$2" ];
}

function _isStartingWithZero () {
    _isStartingWith "$1" 0;
}

function _isIncluding () {
    [[ "$1" =~ $2 ]];
}

function _getShstrNum () {
    printf "$1" | grep -o "$2" | wc -l;
}

# _getShstrInWhichShstrReplaced <shstr> <shstr> <shstr>
# e.g. $ echo "i love apples"
#      i love apples
#      $ _getShstrInWhichShstrReplaced "i love apples" "i" "you"
#      you love apples
function _getShstrInWhichShstrReplaced () {
    eval echo \$'{1//'"$2"'/'"$3"'}'; 
}

# _getShstrInWhichShstrRemoved <shstr> <shstr>
# e.g. $ echo "not good"
#      not good
#      $ _getShstrInWhichShstrRemoved "not good" "not "
#      good
function _getShstrInWhichShstrRemoved () {
    _getShstrInWhichShstrReplaced "$1" "$2";
}

function _getShstrLength () {
    echo ${#1};
}

function _getShintMax () {
    echo $((2 ** 63 - 1));
}

function _getShintMin () {
    echo $((2 ** 63));
}

function _getShintMaxLength () {
    _getShstrLength $(_getShintMax);
}