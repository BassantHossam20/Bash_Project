#!/usr/bin/bash

# Prompt the user for the database name
read -p "Enter the name of the database: " db_name

cd ./DATABASES

# Check if the folder exists
if [ -d "$db_name" ]; then
    echo "Connected to the database folder: $db_name"
    cd "./$db_name"

    # Menu for options
    while true; do
        echo "Choose an option:"
        echo "1) Create Table"
        echo "2) Drop Table"
        echo "3) List Tables"
        echo "4) Update Table"
        echo "5) Delete Data"
        echo "6) Insert Data"
        echo "7) Select Data"
        echo "8) Exit"
        read -p "Enter your choice (1-8): " choice
        
        case $choice in
            1)
                echo "Sourcing Create Table script..."
                source ../../createTable.sh
                ;;
            2)
                echo "Sourcing Drop Table script..."
                source ../../dropTable.sh
                ;;
            3)
                echo "Sourcing List Tables..."
                source ../../listTables.sh
                ;;
            4)
                echo "Sourcing Update Table..."
                source ../../updateData.sh
                ;;
            5)
                echo "Sourcing Delete Data..."
                source ../../deleteData.sh
                ;;
            6)
                echo "Sourcing Insert Data..."
                source ../../insertData.sh
                ;;
            7)
                echo "Sourcing Select Data..."
                source ../../selectData.sh
                ;;
            8)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid choice. Please enter a number between 1 and 8."
                ;;
        esac
    done
else
    echo "Error: The folder '$db_name' does not exist in ./DATABASES."
fi