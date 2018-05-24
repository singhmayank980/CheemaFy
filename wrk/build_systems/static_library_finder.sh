#!/bin/bash
# https://stackoverflow.com/a/13736155/9525551

if [ $# -eq 0 ]; then
    echo "Usage: $0 [--exclude <lib_name>]. . . <link_command>"
fi

exclude=()
lib_path=()

while [ $# -ne 0 ]; do
    case "$1" in
        -L*)
            if [ "$1" == -L ]; then
                shift
                LPATH="-L$1"
            else
                LPATH="$1"
            fi

            lib_path+=("$LPATH")
            echo -n "\"$LPATH\" "
            ;;

        -l*)
            NAME="$(echo $1 | sed 's/-l\(.*\)/\1/')"

            if echo "${exclude[@]}" | grep " $NAME " >/dev/null; then
                echo -n "$1 "
            else
                LIB="$(gcc $lib_path -print-file-name=lib"$NAME".a)"
                if [ "$LIB" == lib"$NAME".a ]; then
                    echo -n "$1 "
                else
                    echo -n "\"$LIB\" "
                fi
            fi
            ;;

        --exclude)
            shift
            exclude+=(" $1 ")
            ;;

        *) echo -n "$1 "
    esac

    shift
done

echo

# usage expample :
# bash static_libraray_filder.sh g++ helo.cpp -lboost_iostreams
