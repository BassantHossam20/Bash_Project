#!/usr/bin/bash

DATABASES_DIR="./DATABASES"
export DATABASES_DIR

# Check if the DATABASES directory exists; if not, create it
if [[ ! -d "$DATABASES_DIR" ]]; then
    mkdir "$DATABASES_DIR"
    echo "Created DATABASES directory."
fi

# Change into the DATABASES directory
cd "$DATABASES_DIR" || { echo "Failed to change directory to $DATABASES_DIR."; exit 1; }

#Enter DB Name and validate it.
while true; 
do 
    read -p "Enter database name or press # to exit: " db_name

    if [[ "$db_name" == "#" ]]; then
        echo "Exiting..."
        exit 0
    fi

    # Replace spaces with underscores
    db_name=$(echo "$db_name" | tr ' ' '_')

    source ../checkname.sh
    checkname "$db_name"
    result=$?

    if [[ $result -eq 0 ]]; then
        export db_name
        break
    fi
done

# Check if the database directory exists
if [[ -d "$db_name" ]]; then
    echo "Database '$db_name' already exists."
else
    mkdir "$db_name"  # Create the new database directory
    echo "Database '$db_name' created successfully!"
fi

# Change into the new or existing database directory
cd "$db_name" || { echo "Failed to change to the database directory."; exit 1; }
echo "Now in database directory: $(pwd)"
