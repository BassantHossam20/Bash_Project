# Bash_Project
# Bash Database Management System

This project implements a simple yet functional Database Management System (DBMS) in Bash. It provides users with essential features for managing databases and tables through command-line interactions. Designed to be lightweight and straightforward, this system is perfect for learning database operations or managing small datasets within a shell environment.

## Features

### Database Operations
- **Create Database:** Create new databases with valid names, ensuring no duplicates.
- **List Databases:** Display all available databases or notify if none exist.
- **Remove Database:** Delete existing databases safely.

### Table Operations
- **Create Table:** Define tables with column specifications while enforcing naming conventions.
- **List Tables:** Show all tables in a database or handle cases where no tables exist.
- **Drop Table:** Remove specific tables from a database.

### Data Operations
- **Insert Data:** Add rows to tables, validating data types and ensuring primary key uniqueness.
- **Update Data:** Modify existing rows in tables based on conditions specified by the user.
- **Delete Data:** Remove rows from tables according to specific criteria.
- **Select Data:** 
  - Retrieve all rows from a table.
  - Fetch specific rows or columns based on user input.

### Error Handling and Validation
- Enforces naming conventions for databases and tables (e.g., no special characters or names starting with numbers).
- Validates data types and primary key constraints.
- Provides user-friendly error messages for operations such as:
  - Attempting to create duplicate databases or tables.
  - Inserting invalid or incomplete data.
  - Performing operations on non-existent databases or tables.

## Test Coverage

This project includes a comprehensive suite of test cases to ensure system stability and reliability. Key scenarios tested include:
- Handling valid and invalid inputs for database and table creation.
- Robust validation of table schemas and data entries.
- Managing edge cases such as duplicate entries, missing columns, or operations on non-existent entities.
- Clear feedback for both successful and failed operations.

All test cases have been thoroughly verified and passed successfully.
