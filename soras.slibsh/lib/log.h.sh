#!/usr/bin/env bash

log() {
    [[ -t 1 ]] && \
        [[ -t 2 ]] && \
        [[ "$(tput colors 2> /dev/null)" -ge 8 ]] && {
            local COLOR_RESET='\033[0m'
            local COLOR_DEBUG='\033[36m'
            local COLOR_INFO='\033[32m'
            local COLOR_WARN='\033[33m'
            local COLOR_ERROR='\033[31m'
            local COLOR_FATAL='\033[41;37m'
    }

    [[ "$1" = debug ]] && {
        ((log_debug_num++))
        printf "%s" "${COLOR_DEBUG}debug: ${COLOR_RESET}"
        shift 1
        printf "%s\n" "$@"
    }
    [[ "$1" = info ]] && {
        ((log_info_num++))
        printf "%s" "${COLOR_INFO}info: ${COLOR_RESET}"
        shift 1
        printf "%s\n" "$@"
    }
    [[ "$1" = warn ]] && {
        ((log_warn_num++))
        printf "%s" "${COLOR_WARN}warning: ${COLOR_RESET}" >&2
        shift 1
        printf "%s\n" "$@" >&2
    }
    [[ "$1" = error ]] && {
        ((log_error_num++))
        printf "%s" "${COLOR_ERROR}error: ${COLOR_RESET}" >&2
        shift 1
        printf "%s\n" "$@" >&2
    }
    [[ "$1" = fatal ]] && {
        ((log_fatal_num++))
        printf "%s" "${COLOR_FATAL}fatal error: ${COLOR_RESET}" >&2
        shift 1
        printf "%s\n" "$@" >&2
    }
}

log_exit_if_has_error() {
    [[ -n $log_error_num ]] && {
        local exit_code=$1
        shift 1
        log fatal "$@"
        exit $exit_code
    }
}