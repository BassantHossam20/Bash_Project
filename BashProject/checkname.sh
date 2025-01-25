#!/usr/bin/bash

function checkname() {

    if [[ ! "$1" =~ ^[a-zA-Z_] ]]; then
        echo "Please try again. Names should start with _ or a letter."
        return 1
    fi
    
    if [[ ! "$1" =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Please try again. Names should only contain letters, _, or numbers."
        return 1
    fi

    echo "This name follow naming conventions"
    return 0
}