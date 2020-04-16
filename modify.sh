#!/bin/bash

usage() {
    echo "usage: modify.sh [-r] [-l | -u ] <directory>"
    echo "       modify.sh [-r] <sed-command> <directory>"
    echo "          -h  Help"
    echo "          -u  Upper case"
    echo "          -l  Lower case"
    echo "          -r  Recursive"
}

modifyRecursive() {
    local upper=$1
    local lower=$2
    local dir="$3"

    echo "Recursive modification: upper $upper; lower $lower; dir $dir"
}

modifySingle() {
    local upper=$1
    local lower=$2
    local dir="$3"

    echo "Single modification: upper $upper; lower $lower; dir $dir"
}

modifySed() {
    local sedCommand="$1"
    local dir="$2"

    echo "Sed modification: sedCommand $sedCommand; dir $dir"
}

modifyRecursiveSed() {
    local sedCommand="$1"
    local dir="$2"

    echo "Recursive sed modification: sedCommand $sedCommand; dir $dir"
}


doMain() {
    local recursive=0
    local upper=0
    local lower=0
    local sedCommand=''
    local dir=''

    while [ "$1" != "" ]; do
        case $1 in
            -u )     upper=1
                     ;;
            -l )     lower=1
                     ;;
            -r )     recursive=1
                     ;;
            -h )     usage
                     exit
                     ;;
            * )      break
                     ;;
        esac
        shift
    done

    ## Validation
    [ $(($upper + $lower)) -eq 2 ] \
        && echo "Both upper & lower cannot be together." \
        && usage
        && exit 1

    [ $# -eq 0 ] && echo "No directory." \
        && usage
        && exit 1

    [ $# -eq 2 -a $(($upper + $lower)) -eq 1 ] \
        && echo "Upper or lower cannot go with sed command." \
        && usage
        && exit 1


    [ $# -eq 2 ] && sedCommand="$1" \
        && shift

    dir="$1"

    ## Logic goes here
    [ $recursive -eq 0 -a -z "$sedCommand" ] \
        && modifySingle $upper $lower $dir \
        && exit 0

    [ $recursive -eq 1 -a -z "$sedCommand" ] \
        && modifyRecursive $upper $lower $dir \
        && exit 0

    [ $recursive -eq 0 ] \
        && modifySed $sedCommand $dir \
        && exit 0

    modifyRecursiveSed $sedCommand $dir \
        && exit 0
}

doMain $@
