# Library Database SQL Case Study

## Project Overview
This project demonstrates relational database design and analytical SQL queries using a library management dataset.

The database was created using MySQL with proper primary key and foreign key relationships to maintain referential integrity.

## Database Tables
The database contains the following tables:

- tbl_publisher
- tbl_library_branch
- tbl_borrower
- tbl_book
- tbl_book_authors
- tbl_book_copies
- tbl_book_loans

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

## Tools Used
- MySQL
- GitHub
