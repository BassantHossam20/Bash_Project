#!/usr/bin/bash

# Check if the directory contains any files or subdirectories
if [ "$(ls -A 2>/dev/null)" ]; then
    ls
else
    echo "No tables available."
fi