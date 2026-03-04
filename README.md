# Library Database SQL Case Study

## Project Overview
This project demonstrates relational database design and analytical SQL queries using a library management dataset.

The database was created using MySQL with proper primary key and foreign key relationships to maintain referential integrity.

## Project Workflow

1. Designed relational database schema
2. Created tables with primary and foreign key constraints
3. Imported CSV dataset files into MySQL tables
4. Performed analytical SQL queries to answer business questions

## Database Tables
The database contains the following tables:

- tbl_publisher
- tbl_library_branch
- tbl_borrower
- tbl_book
- tbl_book_authors
- tbl_book_copies
- tbl_book_loans

## Database Relationships
The tables are connected using foreign key relationships to maintain data integrity:

- Books are linked to publishers through the publisher name.
- Book authors are associated with specific books.
- Book copies track the number of copies available in each library branch.
- Book loans connect borrowers with the books they have borrowed.

## Data Source
CSV files used to populate the tables are stored in the **dataset** folder.

## SQL Concepts Used
- Primary Keys
- Foreign Keys
- INNER JOIN
- LEFT JOIN
- GROUP BY
- HAVING
- Aggregation Functions (COUNT, SUM)

## Business Questions Solved
1. Number of copies of a book in a specific branch
2. Number of copies of a book across all branches
3. Borrowers who have no books checked out
4. Books loaned from a specific branch with borrower details
5. Total books loaned per branch
6. Borrowers with more than five books checked out
7. Books by a specific author available in a branch

## Project Structure

library-database-sql-case-study/
│
├── README.md
├── library_database_queries.sql
└── dataset/
    ├── tbl_publisher.csv
    ├── tbl_library_branch.csv
    ├── tbl_borrower.csv
    ├── tbl_book.csv
    ├── tbl_book_authors.csv
    ├── tbl_book_copies.csv
    └── tbl_book_loans.csv

## Technologies Used
- MySQL
- GitHub
