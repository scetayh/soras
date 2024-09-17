#!/bin/bash

function Ssc_PrintBrand() {
    echo "$ssc_name (Soras Shell Compiler $ssc_version) $ssc_version"
    echo "Copyright (C) 2024 Tarikko-ScetayhChan"
    echo "This is free software; see the source for copying conditions.  There is NO"
    echo "warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
}

function Ssc_CheckParameters() {
    if [ "$#" -ne 2 ]; then
        if [ "$#" -eq 0 ]; then
            Slibsh_PrintMessage_Fafal_SourceExpected "$0"
        elif [ "$#" -eq 1 ]; then
            Slibsh_PrintMessage_Fafal_TargetExpected "$0"
        elif [ "$#" -gt 2 ]; then
            Slibsh_PrintMessage_Fafal_TooManyArguments "$0"
        fi
        exit 1
    fi
}

function Ssc_CheckFiles() {
    [ ! -f "$ssc_source" ] && \
        Slibsh_PrintMessage_Fafal_ItemNotFound "$0" "$ssc_source" && \
            exit 1;
    [ -f "$ssc_target" ] && \
        Slibsh_PrintMessage_Fafal_ItemExists "$0" "$ssc_target" && \
            exit 1;
    [ ! "${ssc_source: -5}" = ".s.sh" ] && \
        Slibsh_PrintMessage_Fafal_InvalidExtensionName "$0" "$ssc_source" && \
            exit 1;
}

function Ssc_WriteCompilationInformation() {
    sed -i "1i\## date: $(date +%Y%m%dT%H%M%SZ)" "$ssc_target"
    sed -i "1i\## host: $(uname -a)" "$ssc_target"
    sed -i "1i\## compiler: $ssc_name-$ssc_version" "$ssc_target"
    sed -i '1i\#!/bin/bash' "$ssc_target"
    sed -i '1a\ ' "$ssc_target"
    sed -i '5a\ ' "$ssc_target"
}

function Ssc_DeleteComments() {
    sed -i '/#/!b;s/^/\n/;ta;:a;s/\n$//;t;s/\n\(\("[^"]*"\)\|\('\''[^'\'']*'\''\)\)/\1\n/;ta;s/\n\([^#]\)/\1\n/;ta;s/\n.*//' "$1"
}