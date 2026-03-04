use  library;
CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(100) PRIMARY KEY,
    publisher_PublisherAddress VARCHAR(255),
    publisher_PublisherPhone VARCHAR(20)
);

select * from tbl_publisher;

CREATE TABLE tbl_library_branch (
    library_branch_BranchID INT AUTO_INCREMENT PRIMARY KEY,
    library_branch_BranchName VARCHAR(100),
    library_branch_BranchAddress VARCHAR(255)
);

select * from tbl_library_branch;

CREATE TABLE tbl_borrower (
    borrower_CardNo INT AUTO_INCREMENT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(100),
    borrower_BorrowerAddress VARCHAR(255),
    borrower_BorrowerPhone VARCHAR(20)
);

select * from tbl_borrower;

CREATE TABLE tbl_book (
    book_BookID INT AUTO_INCREMENT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(100),
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName) ON DELETE CASCADE ON UPDATE CASCADE
);

select * from tbl_book;

CREATE TABLE tbl_book_authors (
    book_authors_AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(100),
    FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID) ON DELETE CASCADE ON UPDATE CASCADE
);

select * from tbl_book_authors;

CREATE TABLE tbl_book_copies (
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    PRIMARY KEY (book_copies_BookID, book_copies_BranchID),
    FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID) ON DELETE CASCADE ON UPDATE CASCADE
);

select * from tbl_book_copies;

CREATE TABLE tbl_book_loans (
    book_loans_LoansID INT AUTO_INCREMENT PRIMARY KEY,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut DATE,
    book_loans_DueDate DATE,
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo) ON DELETE CASCADE ON UPDATE CASCADE
);

select * from tbl_book_loans;


-- 1. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

SELECT SUM(bc.book_copies_No_Of_Copies) AS total_copies
FROM tbl_book b
JOIN tbl_book_copies bc ON b.book_BookID = bc.book_copies_BookID
JOIN tbl_library_branch lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe' AND lb.library_branch_BranchName = 'Sharpstown';


--- 2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?

SELECT lb.library_branch_BranchName, SUM(bc.book_copies_No_Of_Copies) AS total_copies
FROM tbl_book_copies AS bc
JOIN tbl_book AS b ON bc.book_copies_BookID = b.book_BookID
JOIN tbl_library_branch AS lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe'
GROUP BY lb.library_branch_BranchName;

--- 3. Retrieve the names of all borrowers who do not have any books checked out.
SELECT b.borrower_BorrowerName
FROM tbl_borrower AS b
LEFT JOIN tbl_book_loans AS bl ON b.borrower_CardNo = bl.book_loans_CardNo
WHERE bl.book_loans_BookID IS NULL;

--- 4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address.
SELECT 
    tbl_book.book_Title AS BookTitle,
    tbl_borrower.borrower_BorrowerName AS BorrowerName,
    tbl_borrower.borrower_BorrowerAddress AS BorrowerAddress,
    tbl_book_loans.book_loans_DueDate AS DueDate
FROM 
    tbl_book_loans
JOIN 
    tbl_library_branch ON tbl_book_loans.book_loans_BranchID = tbl_library_branch.library_branch_BranchID
JOIN 
    tbl_book ON tbl_book_loans.book_loans_BookID = tbl_book.book_BookID
JOIN 
    tbl_borrower ON tbl_book_loans.book_loans_CardNo = tbl_borrower.borrower_CardNo
WHERE 
    tbl_library_branch.library_branch_BranchID = 1;

--- By the given question i filter BranchID('Sharpstown') with including duedate columns extra . I noticed here there is no matching duedate is present by comparing with BranchID.alter    
--- Finally i conluded here there is no matching value present in given data finally we get only empty rows. Lets check below query to filter as per required you will know answer.alter

SELECT 
    tbl_book.book_Title AS BookTitle,
    tbl_borrower.borrower_BorrowerName AS BorrowerName,
    tbl_borrower.borrower_BorrowerAddress AS BorrowerAddress
FROM 
    tbl_book_loans
JOIN 
    tbl_library_branch ON tbl_book_loans.book_loans_BranchID = tbl_library_branch.library_branch_BranchID
JOIN 
    tbl_book ON tbl_book_loans.book_loans_BookID = tbl_book.book_BookID
JOIN 
    tbl_borrower ON tbl_book_loans.book_loans_CardNo = tbl_borrower.borrower_CardNo
WHERE 
    tbl_library_branch.library_branch_BranchName = 'Sharpstown'
    AND tbl_book_loans.book_loans_DueDate = '2018-02-03';


--- 5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

SELECT lb.library_branch_BranchName, COUNT(bl.book_loans_LoansID) AS total_books_loaned
FROM tbl_library_branch AS lb
LEFT JOIN tbl_book_loans AS bl ON lb.library_branch_BranchID = bl.book_loans_BranchID
GROUP BY lb.library_branch_BranchName;

--- 6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

SELECT 
    b.borrower_BorrowerName, 
    b.borrower_BorrowerAddress, 
    COUNT(bl.book_loans_LoansID) AS books_checked_out
FROM 
    tbl_borrower b
JOIN 
    tbl_book_loans bl ON b.borrower_CardNo = bl.book_loans_CardNo
GROUP BY 
    b.borrower_CardNo
HAVING 
    COUNT(bl.book_loans_LoansID) > 5;


--- 7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

SELECT b.book_Title, SUM(bc.book_copies_No_Of_Copies) AS total_copies
FROM tbl_book AS b
JOIN tbl_book_authors AS ba ON b.book_BookID = ba.book_authors_BookID
JOIN tbl_book_copies AS bc ON b.book_BookID = bc.book_copies_BookID
JOIN tbl_library_branch AS lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE lb.library_branch_BranchName = 'Central'
AND ba.book_authors_AuthorName = 'Stephen King'  -- Use the correct column name
GROUP BY b.book_Title
LIMIT 0, 1000;



    


    
    
    

    





























