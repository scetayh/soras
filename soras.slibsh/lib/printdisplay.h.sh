#!/bin/bash

function Slibsh_PrintDisplay_256Colors() {
    for gis_functions_Print256Colors_fgbg in 38 48; do
        for gis_functions_Print256Colors_color in {0..255}; do
            printf "\e[${gis_functions_Print256Colors_fgbg};5;%sm  %3s  \e[0m" $gis_functions_Print256Colors_color $gis_functions_Print256Colors_color
            if [[ $((($gis_functions_Print256Colors_color + 1) % 6)) == 4 ]]; then
                echo
            fi
        done
    done
}

function Slibsh_PrintDisplay_UnameNeofetchLolcat() {
    if [ -f $(which lolcat) ]; then
        uname -a | lolcat && neofetch | lolcat
    else
        uname -a && neofetch
    fi
}

function Slibsh_PrintDisplay_Ls() {
    ls -ahlF --color $*
}

function Slibsh_PrintDisplay_Cat() {
    cat -n $*
}