#!/usr/bin/bash

# Prompt the user for the table name
read -p "Enter the table name to delete data from it : " tablename

# Check if the table exists
if [[ ! -f "./$tablename" ]]; then
    echo "Table './$tablename' does not exist."
    exit 1
fi

echo "Please select an option:"
select option in "Delete all data" "Delete based on condition" "Quit"; do
    case $option in
        "Delete all data")
            # Delete all lines from the file except metadata (first two lines)
            sed -i '3,$d' "$tablename"
            echo "All data has been deleted."
            ;;
        "Delete based on condition")
            # Prompt the user for column name and value
            read -p "Enter the column name: " column_name
            read -p "Enter the value to match: " value

            # Read column names from the metadata (line 1 of the file)
            metadata=$(head -n 1 "$tablename" | sed 's/^PK://')
            IFS=':' read -r -a columns <<< "$metadata"

            # Find the index of the specified column
            column_index=-1
            for i in "${!columns[@]}"; do
                if [[ "${columns[i]}" == "$column_name" ]]; then
                    column_index=$((i + 1)) # Add 1 because `awk` columns are 1-indexed
                    break
                fi
            done

            if [[ $column_index -eq -1 ]]; then
                echo "Error: Column '$column_name' not found."
            else
                # Delete rows where the specified column matches the value
                awk -F':' -v col="$column_index" -v val="$value" 'NR <= 2 || $col != val' "$tablename" > temp && mv temp "$tablename"
                echo "Rows where $column_name='$value' have been deleted."
            fi
            ;;
        "Quit")
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done


