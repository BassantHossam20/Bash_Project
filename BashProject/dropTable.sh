#!/bin/bash

# Prompt the user for the Table to drop
read -p "Enter the name of the Table: " tablename

# Check if the table exists
if [ -f "$tablename" ]; then
    # Remove the table
    rm "$tablename"
    if [ $? -eq 0 ]; then
        echo "The table '$tablename' has been removed successfully."
    else
        echo "Error: Failed to remove the table '$tablename'."
    fi
else
    # Print an error message
    echo "Error: The table '$tablename' does not exist."
fi
