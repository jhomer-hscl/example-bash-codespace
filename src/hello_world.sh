#!/usr/bin/env bash

source functions.sh

declare -r FILE=file

create_file "my_file"
if [ $? != 0 ]; then
        echo " failed to create file"
fi