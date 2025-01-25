#!/usr/bin/bash

while true; 
do 
    read -p "Enter Table Name or press # to exit: " tablename

    # Exit if user enters #
    if [[ "$tablename" == "#" ]]; then
        echo "Exiting..."
        exit 0
    fi

    # Replace spaces with underscores
    tablename=$(echo "$tablename" | tr ' ' '_')

    # Source the checkname.sh script
    if [[ -f "../../checkname.sh" ]]; then
        source ../../checkname.sh
        checkname "$tablename"
        result=$?
    else
        echo "checkname.sh not found!"
        exit 1
    fi

    # If the name is valid, break out of the loop
    if [[ $result -eq 0 ]]; then
        break
    fi
done

# Check if the database table exists
if [[ -f "$tablename" ]]; then
    echo "Table '$tablename' already exists."
else
    touch "./$tablename"  # Create the new database table
    echo "Table '$tablename' created successfully!"

    # Ask for the number of fields
    while true; do
        read -p "Enter the number of fields for the table: " num_fields
        if [[ "$num_fields" =~ ^[1-9][0-9]*$ ]]; then
            break
        else
            echo "Please enter a valid positive integer."
        fi
    done

    # Prepare metadata
    column_names=()
    column_types=()

    for ((i = 1; i <= num_fields; i++)); do
        read -p "Enter name for field $i: " field_name
        column_names+=("$field_name")

        while true; do
            read -p "Is field '$field_name' a string or int? " field_type
            if [[ "$field_type" == "string" || "$field_type" == "int" ]]; then
                column_types+=("$field_type")
                break
            else
                echo "Invalid type. Please enter 'string' or 'int'."
            fi
        done
    done

    # Add metadata to the file in plain text format
    {
        # Add column names row (comma-separated)
        echo "PK:${column_names[0]}:$(IFS=:; echo "${column_names[*]:1}")"
        # Add column types row (comma-separated)
        echo "$(IFS=:; echo "${column_types[*]}")"
    } > "$tablename"

    echo "Metadata added to '$tablename'."
    echo "First field '${column_names[0]}' is the primary key."
fi