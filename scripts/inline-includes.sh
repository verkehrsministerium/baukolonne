#! /bin/bash

set -e

function inline()
{
    if [ -n "$2" ]
    then
        location="$2"
    else
        location=$(dirname "$1")
    fi

    ignore=false
    while IFS='' read -r line
    do
        include=$(echo "$line" | sed -rn 's/^include (.*)/\1/p')
        if [ "$ignore" == false ] && [ -n "$include" ]
        then
            inline "$location/$include" "$location"
        else
            echo "$line"
        fi

        if [ "$line" == "#~ no-inline" ]
        then
            ignore=true
        else
            ignore=false
        fi
    done < "$1"
}

find src -maxdepth 2 -mindepth 2 -type f -name Makefile | \
    while read -r file
    do
        output="${file#src/}"
        language="$(dirname "$output")"
        mkdir -p "build/$language"

        echo "MAKEFILE_VERSION := $VERSION" > "build/$output"
        echo "MAKEFILE_LANGUAGE := $(dirname "$output")" >> "build/$output"

        inline "$file" >> "build/$output"

        if [[ -f "src/$language/config.mk" ]]
        then
            cp "src/$language/config.mk" "build/$language"
        fi
    done
