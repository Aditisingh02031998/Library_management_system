SELECT * FROM members;
SELECT * FROM branch;
SELECT * FROM employees;
Select * from books;
SELECT * FROM issued_status;
SELECT * FROM return_status;

-- Project Task
-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
Select * from books;

-- Task 2: Update an Existing Member's Address

UPDATE MEMBERS
Set member_address = '125 Oak St'
where member_id = 'C103';
SELECT * FROM members;

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

Delete from issued_status
where issued_id = 'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

Select issued_book_name 
from issued_status
where issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

Select issued_member_id, count(issued_book_name) as number_book_issued
from issued_status
Group by 1
having count(issued_book_name) >1 ;

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

Create Table book_summary as
Select b.isbn, b. book_title,
  count(I.issued_book_isbn) as issued_count
from 
books b
join
issued_status I 
on 
b.isbn = I.issued_book_isbn
Group by 1,2;

Select * from book_summary;

-- Task 7. Retrieve All Books in a Specific Category:'Classic'

Select * from books 
where category = 'Classic';

--Task 8: Find Total Rental Income by Category:

Select category, Sum(rental_price), count(*)
from 
books b
join
issued_status I 
on 
b.isbn = I.issued_book_isbn
group by 1
;

-- Task 9 List Members Who Registered in the Last 180 Days:

Select * from members 
where reg_date >= current_date - interval '180 days';

-- List Employees with Their Branch Manager's Name and their branch details:

Select E.emp_name, F.emp_name, b.*
from
Employees E join Branch B on E.branch_id = b.branch_id
join Employees F on b.manager_id = f.emp_id

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
--using CTAS 
Create table RetailBooks As 
Select * from books
where rental_price >7;

Select * from RetailBooks;

-- Task 12: Retrieve the List of Books Not Yet Returned

Select * from books;
SELECT * FROM return_status;
SELECT * FROM issued_status;

Select i.issued_book_name from 
issued_status i  left join return_status r on
i.issued_id =  r.issued_id
where r.return_id is null
;


-- Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.
SELECT * FROM members;
Select * from books;
SELECT * FROM return_status;
SELECT * FROM issued_status;

Select m.member_id,m.member_name, b.book_title, i.issued_date, current_date - i.issued_date as Overdue_days
from issued_status i 
join 
members m on m.member_id = i.issued_member_id
join 
books b on b.isbn = i.issued_book_isbn
left join
return_status rs on i.issued_id =  rs.issued_id
where rs.return_id is null 
and (current_date - i.issued_date) > 30
order by 1
;

