#!/usr/bin/env bash

# example function that we can test with bats
#
function create_file() {
    local file="$1"
    printf "creating [%s]" "$file"
        touch $file
}
