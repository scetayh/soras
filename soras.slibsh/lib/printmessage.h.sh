#!/bin/bash

# usage: Slibsh_PrintMessage <process> (debug | info | warning | error | fafal) <message>
# `debug', etc. can be omitted as `d', etc.
function Slibsh_PrintMessage() {
    echo -n "$1: "
    [[ "$2" = d* ]] && echo -en "\e[1m\e[037mdebug: \e[0m"
    [[ "$2" = i* ]] && echo -en "\e[1m\e[092minfo: \e[0m"
    [[ "$2" = w* ]] && echo -en "\e[1m\e[093mwarning: \e[0m"
    [[ "$2" = e* ]] && echo -en "\e[1m\e[091merror: \e[0m"
    [[ "$2" = f* ]] && echo -en "\e[1m\e[031mfafal: \e[0m"
    echo "$3"
}

function Slibsh_PrintMessage_Debug() {
    Slibsh_PrintMessage "$1" d "$2"
}

function Slibsh_PrintMessage_Info() {
    Slibsh_PrintMessage "$1" i "$2"
}

function Slibsh_PrintMessage_Warning() {
    Slibsh_PrintMessage "$1" w "$2"
}

function Slibsh_PrintMessage_Error() {
    Slibsh_PrintMessage "$1" e "$2"
}

function Slibsh_PrintMessage_Fafal() {
    Slibsh_PrintMessage "$1" f "$2"
}

function Slibsh_PrintMessage_Fafal_SourceExpected() {
    Slibsh_PrintMessage_Fafal "$1" "Source expected."
}

function Slibsh_PrintMessage_Fafal_TargetExpected() {
    Slibsh_PrintMessage_Fafal "$1" "Target expected."
}

function Slibsh_PrintMessage_Fafal_TooManyArguments() {
    Slibsh_PrintMessage_Fafal "$1" "To many arguments."
}

function Slibsh_PrintMessage_Fafal_ItemNotFound() {
    Slibsh_PrintMessage_Fafal "$1" "\`$2' not found."
}

function Slibsh_PrintMessage_Fafal_ItemExists() {
    Slibsh_PrintMessage_Fafal "$1" "\`$2' exists."
}

function Slibsh_PrintMessage_Fafal_InvalidExtensionName() {
    Slibsh_PrintMessage_Fafal "$1" "Invalid extension name in \`$2'."
}