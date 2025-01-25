#!/bin/bash

# Prompt the user for the table name
read -p "Enter the table name to select data from it: " tablename

# Check if the table exists
if [[ ! -e "$tablename" ]]; then
    echo "Table '$tablename' does not exist."
    exit 1
fi

echo "Please select an option:"
select option in "Select all data" "Select based on condition" "Select specific column" "Quit"; do
    case $option in
        "Select all data")
            # Display the entire table, excluding metadata
            echo "Table contents:"
            tail -n +3 "$tablename"
            ;;

        "Select based on condition")
            echo "Select based on condition"

            # Read column names from metadata
            metadata=$(head -n 1 "$tablename" | sed 's/^PK://')
            if [[ -z "$metadata" ]]; then
                echo "Error: No metadata found in the file."
                exit 1
            fi

            IFS=':' read -r -a columns <<< "$metadata"

            # Display column names as a menu
            echo "Select a column for the condition:"
            select col in "${columns[@]}" "Back to main menu"; do
                if [[ $col == "Back to main menu" ]]; then
                    break
                elif [[ -n $col ]]; then
                    # Prompt for condition and value
                    read -p "Enter the condition (<, >, or =): " condition
                    if [[ $condition != "<" && $condition != ">" && $condition != "=" ]]; then
                        echo "Invalid condition. Please enter <, >, or =."
                        continue
                    fi

                    read -p "Enter the value to compare: " value

                    # Find the column index
                    column_index=-1
                    for i in "${!columns[@]}"; do
                        if [[ "${columns[i]}" == "$col" ]]; then
                            column_index=$((i + 1))
                            break
                        fi
                    done

                    if [[ $column_index -ne -1 ]]; then
                        echo "Matching row(s):"
                        awk -F':' -v col="$column_index" -v cond="$condition" -v val="$value" '
                        BEGIN { found = 0 }
                        NR > 2 && ((cond == "<" && $col + 0 < val + 0) || 
                                   (cond == ">" && $col + 0 > val + 0) || 
                                   (cond == "=" && $col == val)) {
                            print; found = 1
                        }
                        END { if (found == 0) print "No matching rows found." }' "$tablename"
                    else
                        echo "Column '$col' not found."
                    fi
                    break
                else
                    echo "Invalid option. Please try again."
                fi
            done
            ;;
        "Select specific column")
            # Read column names from metadata
            metadata=$(head -n 1 "$tablename" | sed 's/^PK://')
            IFS=':' read -r -a columns <<< "$metadata"

            # Display column names as a menu
            echo "Select a column to display:"
            select col in "${columns[@]}" "Back to main menu"; do
                if [[ $col == "Back to main menu" ]]; then
                    break
                elif [[ -n $col ]]; then
                    # Find the column index
                    column_index=-1
                    for i in "${!columns[@]}"; do
                        if [[ "${columns[i]}" == "$col" ]]; then
                            column_index=$((i + 1))  # `awk` is 1-indexed
                            break
                        fi
                    done

                    if [[ $column_index -ne -1 ]]; then
                        echo "Data for column '$col':"
                        awk -F':' -v col="$column_index" 'NR > 2 { print $col }' "$tablename"
                    else
                        echo "Column '$col' not found."
                    fi
                    break
                else
                    echo "Invalid option. Please try again."
                fi
            done
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


