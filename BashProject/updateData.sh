#!/usr/bin/bash

# Prompt the user for the table name
read -p "Enter the table name to update data : " tablename

# Check if the table exists
if [[ ! -f "./$tablename" ]]; then
    echo "Table './$tablename' does not exist."
    exit 1
fi

# Read column names from metadata (assuming the first line contains metadata)
metadata=$(head -n 1 "$tablename" | sed 's/^PK://')
IFS=':' read -r -a columns <<< "$metadata"

# Display column names as a menu
echo "Select a column to update:"
select col in "${columns[@]}" "Back to main menu"; do
    if [[ $col == "Back to main menu" ]]; then
        break
    elif [[ -n $col ]]; then
        # Get primary key column (assumed to be the first column in the table)
        pk_column="${columns[0]}"

        # Ask for the primary key value
        read -p "Enter the primary key value for the row to update: " pk_value

        # Find the row with the given primary key value
        row=$(awk -F':' -v pk_col="$pk_column" -v pk_val="$pk_value" '$1 == pk_val {print NR, $0}' "$tablename")
        
        if [[ -z "$row" ]]; then
            echo "No row with primary key '$pk_value' found."
            break
        else
            # Extract the line number of the matching row
            line_number=$(echo "$row" | cut -d' ' -f1)

            # Ask for the new value to update in the selected column
            read -p "Enter the new value for column '$col': " new_value

            # Find the column index
            column_index=-1
            for i in "${!columns[@]}"; do
                if [[ "${columns[i]}" == "$col" ]]; then
                    column_index=$((i + 1))  # `awk` is 1-indexed
                    break
                fi
            done

            # Update the data in the selected column
            awk -F':' -v line_number="$line_number" -v col="$column_index" -v new_val="$new_value" -v OFS=":" '
                NR == line_number {
                    $col = new_val
                }
                {print $0}
            ' "$tablename" > temp_file && mv temp_file "$tablename"

            echo "Table updated successfully."
        fi
        break
    else
        echo "Invalid option. Please try again."
    fi
done