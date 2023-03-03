#!/usr/bin/env bash

if [[ ! $1 ]]; then
    # Always returns a path relative to the scipt
    #
    config_file="$(dirname "$(dirname "$(realpath "$0")")")"/tests/data/config.json
else
    config_file="$1"
fi

# Pull some values from config.json else default to var1=foo and var2=bar
#
if ! CONFIG=$(jq '.' "$config_file"); then
    echo "Error reading config: $config_file"
    exit "1"
fi

VAR1=$(echo "$CONFIG" | jq '.var1 // "value1"' | tr -d \")
VAR2=$(echo "$CONFIG" | jq '.var2 // "value2"' | tr -d \")

# run a command to check something
#
if ! fuser 8080/tcp 2>/dev/null 1>/dev/null; then
    printf "Var1:\t%s\n" "$VAR1"
    printf "Var2:\t%s\n" "$VAR2"
else
    echo "We checked something and didn't need to print out anything"
fi
