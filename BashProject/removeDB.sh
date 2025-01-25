#!/usr/bin/bash
cd ./DATABASES
# Prompt the user for the database name
read -p "Enter the name of the database: " db_name

# Define the path to the database folder
db_path="$db_name"

# Check if the folder exists
if [ -d "$db_path" ]; then
    # Remove the folder
    echo $PWD
    rm -r "$db_path"
    echo "The folder '$db_name' has been removed from ./DATABASES."
else
    # Print an error message
    echo "Error: The folder '$db_name' does not exist in ./DATABASES."
fi