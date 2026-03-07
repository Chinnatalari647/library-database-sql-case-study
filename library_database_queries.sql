-- =====================================================
-- Library Database SQL Case Study
-- Author: Chinna Talari
-- Description: Relational database schema creation and
--              analytical SQL queries for library system
-- =====================================================


-- =====================================================
-- 1. DATABASE SELECTION
-- =====================================================

USE library;


-- =====================================================
-- 2. TABLE CREATION
-- =====================================================


-- -----------------------------------------------------
-- Table: Publisher
-- -----------------------------------------------------

CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(100) PRIMARY KEY,
    publisher_PublisherAddress VARCHAR(255),
    publisher_PublisherPhone VARCHAR(20)
);

-- Used during development to verify table structure
-- SELECT * FROM tbl_publisher;



-- -----------------------------------------------------
-- Table: Library Branch
-- -----------------------------------------------------

CREATE TABLE tbl_library_branch (
    library_branch_BranchID INT AUTO_INCREMENT PRIMARY KEY,
    library_branch_BranchName VARCHAR(100),
    library_branch_BranchAddress VARCHAR(255)
);

-- Used during development to verify table structure
-- SELECT * FROM tbl_library_branch;



-- -----------------------------------------------------
-- Table: Borrower
-- -----------------------------------------------------

CREATE TABLE tbl_borrower (
    borrower_CardNo INT AUTO_INCREMENT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(100),
    borrower_BorrowerAddress VARCHAR(255),
    borrower_BorrowerPhone VARCHAR(20)
);

-- Used during development to verify table structure
-- SELECT * FROM tbl_borrower;



-- -----------------------------------------------------
-- Table: Book
-- -----------------------------------------------------

CREATE TABLE tbl_book (
    book_BookID INT AUTO_INCREMENT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(100),
    FOREIGN KEY (book_PublisherName)
    REFERENCES tbl_publisher(publisher_PublisherName)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Used during development to verify table structure
-- SELECT * FROM tbl_book;



-- -----------------------------------------------------
-- Table: Book Authors
-- -----------------------------------------------------

CREATE TABLE tbl_book_authors (
    book_authors_AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(100),
    FOREIGN KEY (book_authors_BookID)
    REFERENCES tbl_book(book_BookID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Used during development to verify table structure
-- SELECT * FROM tbl_book_authors;



-- -----------------------------------------------------
-- Table: Book Copies
-- -----------------------------------------------------

CREATE TABLE tbl_book_copies (
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    PRIMARY KEY (book_copies_BookID, book_copies_BranchID),
    FOREIGN KEY (book_copies_BookID)
    REFERENCES tbl_book(book_BookID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (book_copies_BranchID)
    REFERENCES tbl_library_branch(library_branch_BranchID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Used during development to verify table structure
-- SELECT * FROM tbl_book_copies;



-- -----------------------------------------------------
-- Table: Book Loans
-- -----------------------------------------------------

CREATE TABLE tbl_book_loans (
    book_loans_LoansID INT AUTO_INCREMENT PRIMARY KEY,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut DATE,
    book_loans_DueDate DATE,
    FOREIGN KEY (book_loans_BookID)
    REFERENCES tbl_book(book_BookID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_BranchID)
    REFERENCES tbl_library_branch(library_branch_BranchID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_CardNo)
    REFERENCES tbl_borrower(borrower_CardNo)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Used during development to verify table structure
-- SELECT * FROM tbl_book_loans;



-- =====================================================
-- 3. ANALYTICAL SQL QUERIES
-- =====================================================


-- -----------------------------------------------------
-- Question 1
-- How many copies of the book "The Lost Tribe"
-- are owned by the library branch "Sharpstown"?
-- -----------------------------------------------------

SELECT SUM(bc.book_copies_No_Of_Copies) AS total_copies
FROM tbl_book b
JOIN tbl_book_copies bc
ON b.book_BookID = bc.book_copies_BookID
JOIN tbl_library_branch lb
ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe'
AND lb.library_branch_BranchName = 'Sharpstown';



-- -----------------------------------------------------
-- Question 2
-- How many copies of "The Lost Tribe"
-- are owned by each library branch?
-- -----------------------------------------------------

SELECT lb.library_branch_BranchName,
       SUM(bc.book_copies_No_Of_Copies) AS total_copies
FROM tbl_book_copies bc
JOIN tbl_book b
ON bc.book_copies_BookID = b.book_BookID
JOIN tbl_library_branch lb
ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe'
GROUP BY lb.library_branch_BranchName;



-- -----------------------------------------------------
-- Question 3
-- Retrieve the names of borrowers who
-- do not have any books checked out
-- -----------------------------------------------------

SELECT b.borrower_BorrowerName
FROM tbl_borrower b
LEFT JOIN tbl_book_loans bl
ON b.borrower_CardNo = bl.book_loans_CardNo
WHERE bl.book_loans_BookID IS NULL;



-- -----------------------------------------------------
-- Question 4
-- Retrieve books loaned from the "Sharpstown" branch
-- with DueDate = '2018-02-03'
-- -----------------------------------------------------

SELECT
    tbl_book.book_Title AS BookTitle,
    tbl_borrower.borrower_BorrowerName AS BorrowerName,
    tbl_borrower.borrower_BorrowerAddress AS BorrowerAddress
FROM tbl_book_loans
JOIN tbl_library_branch
ON tbl_book_loans.book_loans_BranchID = tbl_library_branch.library_branch_BranchID
JOIN tbl_book
ON tbl_book_loans.book_loans_BookID = tbl_book.book_BookID
JOIN tbl_borrower
ON tbl_book_loans.book_loans_CardNo = tbl_borrower.borrower_CardNo
WHERE tbl_library_branch.library_branch_BranchName = 'Sharpstown'
AND tbl_book_loans.book_loans_DueDate = '2018-02-03';

-- Note:
-- If no rows are returned, it means no books were due on
-- that specific date from the Sharpstown branch.



-- -----------------------------------------------------
-- Question 5
-- Retrieve the total number of books loaned
-- from each library branch
-- -----------------------------------------------------

SELECT lb.library_branch_BranchName,
       COUNT(bl.book_loans_LoansID) AS total_books_loaned
FROM tbl_library_branch lb
LEFT JOIN tbl_book_loans bl
ON lb.library_branch_BranchID = bl.book_loans_BranchID
GROUP BY lb.library_branch_BranchName;



-- -----------------------------------------------------
-- Question 6
-- Borrowers who have checked out more than
-- five books
-- -----------------------------------------------------

SELECT
    b.borrower_BorrowerName,
    b.borrower_BorrowerAddress,
    COUNT(bl.book_loans_LoansID) AS books_checked_out
FROM tbl_borrower b
JOIN tbl_book_loans bl
ON b.borrower_CardNo = bl.book_loans_CardNo
GROUP BY b.borrower_CardNo
HAVING COUNT(bl.book_loans_LoansID) > 5;



-- -----------------------------------------------------
-- Question 7
-- Books authored by "Stephen King"
-- available in the "Central" branch
-- -----------------------------------------------------

SELECT b.book_Title,
       SUM(bc.book_copies_No_Of_Copies) AS total_copies
FROM tbl_book b
JOIN tbl_book_authors ba
ON b.book_BookID = ba.book_authors_BookID
JOIN tbl_book_copies bc
ON b.book_BookID = bc.book_copies_BookID
JOIN tbl_library_branch lb
ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE lb.library_branch_BranchName = 'Central'
AND ba.book_authors_AuthorName = 'Stephen King'
GROUP BY b.book_Title;
