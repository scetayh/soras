#!/bin/bash

export ssc_name=ssc
export ssc_version=0.0.1

#.include {
source /usr/local/lib/slibsh/printmessage.h.sh
source ../lib/functions.h.sh
#.}

Ssc_PrintBrand
Ssc_CheckParameters "$@"
ssc_source="$1"
ssc_target="$2"
Ssc_CheckFiles
ssc_sourceLineNumber=$(wc -l <"$ssc_source")

for ((i = 1; i <= ssc_sourceLineNumber; i++)); do
    [ "$(sed -n "${i}p" "$ssc_source")" = '#.include {' ] &&
        export ssc_includeHead=$((i + 1)) &&
        break
done

if [ -z "$ssc_includeHead" ]; then
    cat "$ssc_source" >>"$ssc_target"
else
    for ((i = ssc_includeHead; i <= ssc_sourceLineNumber; i++)); do
        [ "$(sed -n "${i}p" "$ssc_source")" = '#.}' ] &&
            export ssc_includeTail=$((i - 1)) &&
            break
    done

    if [ -z "$ssc_includeTail" ]; then
        Slibsh_PrintMessage_Fafal "$0" "\`#.}' expected." &&
            exit 1
    else
        sed -n "1,$((ssc_includeHead - 2))p" "$ssc_source" >>"$ssc_target"

        for ((i = ssc_includeHead; i <= ssc_includeTail; i++)); do
            ssc_currentContent="$(sed -n "${i}p" "$ssc_source")"
            export ssc_currentContent
            eval "$ssc_currentContent"
        done

        typeset -f >>"$ssc_target"

        sed -n "$((ssc_includeTail + 2)),$((ssc_sourceLineNumber + 1))p" "$ssc_source" >>"$ssc_target"
    fi
fi

Ssc_WriteCompilationInformation
chmod 555 -R "$ssc_target"