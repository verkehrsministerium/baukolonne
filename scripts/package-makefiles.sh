#! /bin/bash

set -e

mkdir -p package
find build -maxdepth 1 -mindepth 1 -type d | \
    while read -r build
    do
        language=${build#build/}
        tar -C "$build" -czf "package/$language-$VERSION.tgz" .
    done
