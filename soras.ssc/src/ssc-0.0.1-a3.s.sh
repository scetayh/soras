#!/bin/bash
# SSC version 0.0.1-a3
export procname="ssc"
if [ -n "$1" ]; then
    if [ -n "$2" ]; then
        export target="$2"
    else
        export target=a.out.sh
    fi
    for ((i=1; i>0; i++)); do
        if [ "$(wc -l < "$1")" -gt 0 ]; then
            for ((i=1; i<=$(wc -l < "$1"); i++)); do
                export lineContent=$(sed -n ${i}p "$1" )
                if [ "$lineContent" = "##include {" ]; then
                    export lineIncludeStart=$i
                    break
                fi
            done
            for ((i=1; i<=$(wc -l < "$1"); i++)); do
                export lineContent=$(sed -n ${i}p "$1" )
                #echo "\$lineContent=$lineContent"
                if [ "$lineContent" = "##}" ]; then
                    export lineIncludeEnd=$i
                    break
                fi
            done
            sed -n 1,$((lineIncludeStart - 1))p "$1" > "${target}"
            for ((i=$((lineIncludeStart + 1)); i<=$((lineIncludeEnd - 1)); i++)); do
                export lineContent=$(sed -n ${i}p "$1" )
                cat "${lineContent#*source }" >> "${target}"
            done
            sed -n $((lineIncludeEnd + 1)),$(wc -l < "$1")p "$1" >> "${target}"
        fi
    done
else
    echo "$procname: fatal error: no input files"
    echo "compilation terminated."
    exit 1
fi