#!/bin/bash

# Main Menu
while true; do
    echo "=============================="
    echo "     DATABASE MANAGEMENT      "
    echo "=============================="
    echo "1) Connect to Database"
    echo "2) List Databases"
    echo "3) Create Database"
    echo "4) Remove Database"
    echo "5) Exit"
    echo "=============================="
    read -p "Enter your choice: " choice

    case $choice in
        1)
            ./connectDB.sh
            ;;
        2)
            ./listDB.sh
            ;;
        3)
            ./createDB.sh
            ;;
        4)
            ./removeDB.sh
            ;;
        5)
            echo "Exiting... Goodbye!"
            break
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done
