#!/usr/bin/env bash

if [[ ! $1 ]]; then
    config_file=tests/data/config.json
else
    config_file=$1
fi

# Pull some values from config.json else default to var1=foo and var2=bar
#
CONFIG=$(cat $config_file | jq '.')
VAR1=$(echo $CONFIG | jq '.var1 // "value1"' | tr -d \")
VAR2=$(echo $CONFIG | jq '.var2 // "value2"' | tr -d \")

# run a command to check something
#
result=$(fuser 8080/tcp 2>/dev/null 1>/dev/null)

if [[ ! $? == 0 ]]; then
    echo Var1:\t$VAR1\n
    printf "Var2:\t$VAR2\n"
else
    echo "We checked something and didn't need to print out anything"
fi
