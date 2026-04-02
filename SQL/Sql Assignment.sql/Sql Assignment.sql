
DROP DATABASE IF EXISTS MarketCo;


CREATE DATABASE MarketCo;
USE MarketCo;


CREATE TABLE Company (
    CompanyID INT PRIMARY KEY,
    CompanyName VARCHAR(45),
    Street VARCHAR(45),
    City VARCHAR(45),
    State VARCHAR(2),
    Zip VARCHAR(10)
);

CREATE TABLE Contact (
    ContactID INT PRIMARY KEY,
    CompanyID INT,
    FirstName VARCHAR(45),
    LastName VARCHAR(45),
    Street VARCHAR(45),
    City VARCHAR(45),
    State VARCHAR(2),
    Zip VARCHAR(10),
    IsMain BOOLEAN,
    Email VARCHAR(45),
    Phone VARCHAR(12),
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(45),
    LastName VARCHAR(45),
    Salary DECIMAL(10,2),
    HireDate DATE,
    JobTitle VARCHAR(25),
    Email VARCHAR(45),
    Phone VARCHAR(12)
);

CREATE TABLE ContactEmployee (
    ContactEmployeeID INT PRIMARY KEY,
    ContactID INT,
    EmployeeID INT,
    ContactDate DATE,
    Description VARCHAR(100),
    FOREIGN KEY (ContactID) REFERENCES Contact(ContactID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);


INSERT INTO Company VALUES 
(1, 'Toll Brothers', 'Street1', 'NYC', 'NY', '10001'),
(2, 'Urban Outfitters, Inc.', 'Street2', 'LA', 'CA', '90001');

INSERT INTO Contact VALUES 
(1, 1, 'Dianne', 'Connor', 'Street', 'NYC', 'NY', '10001', TRUE, 'dianne@email.com', '1234567890');

INSERT INTO Employee VALUES 
(1, 'Jack', 'Lee', 50000, '2020-01-01', 'Manager', 'jack@email.com', '1111111111'),
(2, 'Lesley', 'Bland', 60000, '2019-01-01', 'HR', 'lesley@email.com', '2222222222');

INSERT INTO ContactEmployee VALUES 
(1, 1, 1, '2023-01-01', 'Meeting');


UPDATE Employee
SET Phone = '215-555-8800'
WHERE EmployeeID = 2;

-- STEP 5: SAFE UPDATE (FIXED ✅)
UPDATE Company
SET CompanyName = 'Urban Outfitters'
WHERE CompanyID = 2;

-- STEP 6: SAFE DELETE (FIXED ✅)
DELETE FROM ContactEmployee
WHERE ContactEmployeeID = 1;

-- STEP 7: SELECT QUERY
SELECT DISTINCT e.FirstName, e.LastName
FROM Employee e
JOIN ContactEmployee ce ON e.EmployeeID = ce.EmployeeID
JOIN Contact c ON ce.ContactID = c.ContactID
JOIN Company co ON c.CompanyID = co.CompanyID
WHERE co.CompanyName = 'Toll Brothers';

-- STEP 8: Check Data
SELECT * FROM Company;
SELECT * FROM Employee;
SELECT * FROM ContactEmployee;


--------------------------------------THEORY QUATION  AND ANSWER ------------------------------------------------

QUATION 8  -- Meaning of “%” and “_” in LIKE

| Symbol | Meaning                                            
| ------ | -------------------------------------------------- 
| `%`    | Matches **any sequence of characters** (0 or more) 
| `_`    | Matches **exactly one character**                  



QUATION 9 -- Explain normalization in the context of databases.

      Normalization is the process of organizing data in a database to reduce redundancy and improve data integrity.
	  It involves dividing large tables into smaller related ones and defining relationships between them.

    ==Common normal forms:

	1NF: Remove repeating groups.
	2NF: Remove partial dependencies.
	3NF: Remove transitive dependencies.
	

QUATION 10= Meaning of JOIN in MySQL


LEFT JOIN: Returns all rows from the left table + matching rows from the right.
RIGHT JOIN: Returns all rows from the right table + matching rows from the left.
OUTER JOIN: Combines left and right joins.
CROSS JOIN: Returns all possible combinations.

SELECT e.FirstName, e.LastName, ce.Description
FROM Employee e
JOIN ContactEmployee ce ON e.EmployeeID = ce.EmployeeID
JOIN Contact c ON ce.ContactID = c.ContactID;


QUATION 11 -- Difference between DDL, DCL, and DML

 
| Type    | Full Form                  | Purpose                         | Examples                               |
| ------- | -------------------------- | ------------------------------- | -------------------------------------- |
| **DDL** | Data Definition Language   | Defines structure of DB objects | `CREATE`, `ALTER`, `DROP`, `TRUNCATE`  |
| **DML** | Data Manipulation Language | Manages data inside tables      | `SELECT`, `INSERT`, `UPDATE`, `DELETE` |
| **DCL** | Data Control Language      | Controls access to data         | `GRANT`, `REVOKE`                      |



QUATION 12 ---What is the role of the MySQL JOIN clause in a query, and what are some common types of joins?

The JOIN clause is used to retrieve data from multiple tables by matching related columns.

Common types of joins:
INNER JOIN: Returns matching rows from both tables.
LEFT JOIN: Returns all rows from the left table, and matched rows from the right table.
RIGHT JOIN: Returns all rows from the right table, and matched rows from the left table.
FULL OUTER JOIN: Returns all rows when there is a match in either table (not directly supported in MySQL, can be simulated).
CROSS JOIN: Returns the Cartesian product of both tables.




