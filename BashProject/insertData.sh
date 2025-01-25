#!/usr/bin/bash

# Prompt the user for the table name
read -p "Enter the table name to insert data into: " tablename

# Check if the table exists
if [[ ! -f "./$tablename" ]]; then
    echo "Table './$tablename' does not exist."
    exit 1
fi

# Read metadata from the table
metadata=$(head -n 1 "./$tablename" | sed 's/^PK://')
pk_column=$(echo "$metadata" | cut -d':' -f1)  # Extract the primary key column
column_names=$(echo "$metadata" | cut -d':' -f2-)  # Extract the other column names
IFS=':' read -r -a column_types <<< "$(sed -n '2p' "./$tablename")"  # Get column types

# Read existing primary key values for uniqueness check
existing_pks=($(awk -F':' '
    NR > 2 {
        print $1  # Assuming the primary key is the first field
    }
' "./$tablename"))

# Function to validate input based on type
validate_input() {
    local type="$1"
    local value="$2"
    local column="$3"

    if [[ "$type" == "int" ]]; then
        if [[ ! "$value" =~ ^[0-9]+$ ]]; then
            echo "Error: $column must be an integer."
            return 1
        fi
    elif [[ "$type" == "string" ]]; then
        if [[ ! "$value" =~ ^[a-zA-Z_[:space:]]+$ ]]; then
            echo "Error: $column must be a string (alphanumeric, underscores, and spaces allowed)."
            return 1
        fi
    fi

    return 0
}

# Prompt for primary key entry with type validation
while true; do
    read -p "Enter value for $pk_column (Primary Key): " pk_value

    # Check if the primary key is unique
    if [[ " ${existing_pks[@]} " =~ " $pk_value " ]]; then
        echo "Error: Primary key value '$pk_value' already exists. Please enter a unique value."
        continue
    fi

    # Validate the primary key based on its type
    pk_type="${column_types[0]}"
    if ! validate_input "$pk_type" "$pk_value" "$pk_column"; then
        continue
    fi

    break  # Valid primary key, exit the loop
done

# Start collecting data for the remaining columns
data=("$pk_value")  # Initialize the data array with the primary key value
IFS=':' read -r -a other_columns <<< "$column_names"  # Split remaining column names

# Loop through each column to get user input with type validation
for i in "${!other_columns[@]}"; do
    column="${other_columns[i]}"
    type="${column_types[i + 1]}"  # Offset by 1 as the first type is for the primary key

    while true; do
        read -p "Enter value for $column: " value

        # Validate the input based on the column type
        if ! validate_input "$type" "$value" "$column"; then
            continue
        fi

        # Valid value
        data+=("$value")
        break
    done
done

# Insert the new row into the table
{
    echo "$(IFS=:; echo "${data[*]}")"
} >> "./$tablename"

echo "Data successfully inserted into './$tablename'."
