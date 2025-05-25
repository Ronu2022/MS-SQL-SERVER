# MS-SQL-SERVER
A Beginner's Guide to Microsoft SQL Server

Welcome to this guide on Microsoft SQL Server (MS SQL Server), a powerful relational database management system (RDBMS) used for storing, managing, and querying data. This README covers the fundamentals of MS SQL Server, with practical examples inspired by fintech scenarios like managing loan application data at Spring Financial. Whether you're a data analyst, engineer, or beginner, this guide will help you get started.



Table of Contents





What is MS SQL Server?



Key Concepts





Databases



Tables



Queries



Joins



Stored Procedures



Triggers



Basic Examples



Getting Started



Best Practices



Resources



What is MS SQL Server?

MS SQL Server is a relational database management system developed by Microsoft. It stores data in tables, supports SQL (Structured Query Language) for querying, and is widely used in industries like finance, healthcare, and retail for managing structured data.





Key Features:





Scalable for small to enterprise-level applications.



Supports T-SQL (Transact-SQL), an extension of SQL.



Integrates with Microsoft tools (e.g., SSMS, Azure).



Ensures data security and compliance (e.g., GDPR, PIPEDA).

Use Case: At Spring Financial, MS SQL Server could store loan application data, enabling analysts to query customer information for underwriting.



Key Concepts

Databases

A database is a container for storing related data in tables. Each database has a schema defining its structure.





Example: A FintechDB database for Spring Financial’s loan data.



T-SQL:

CREATE DATABASE FintechDB;

Tables

Tables store data in rows and columns, with each column having a specific data type (e.g., VARCHAR, INT, DATE).





Example: A LoanApplications table for loan details.



T-SQL:

USE FintechDB;
CREATE TABLE LoanApplications (
    LoanID VARCHAR(50) PRIMARY KEY,
    Email VARCHAR(100),
    ApplicationDate DATE,
    LoanAmount DECIMAL(10,2)
);

Queries

Queries retrieve or manipulate data using SELECT, INSERT, UPDATE, and DELETE.





Example: Fetch loans applied after May 1, 2025.



T-SQL:

SELECT LoanID, Email, LoanAmount
FROM LoanApplications
WHERE ApplicationDate > '2025-05-01';

Joins

Joins combine data from multiple tables based on related columns.





Example: Join LoanApplications with a Customers table.



T-SQL:

SELECT l.LoanID, l.LoanAmount, c.CustomerName
FROM LoanApplications l
INNER JOIN Customers c ON l.Email = c.Email;

Stored Procedures

Stored procedures are reusable T-SQL scripts for complex operations.





Example: Validate email formats in LoanApplications.



T-SQL:

CREATE PROCEDURE ValidateEmails
AS
BEGIN
    SELECT LoanID, Email
    FROM LoanApplications
    WHERE Email NOT LIKE '%_@_%._%';
END;
EXEC ValidateEmails;

Triggers

Triggers are automated actions executed on table events (e.g., INSERT, UPDATE).





Example: Log updates to LoanApplications.



T-SQL:

CREATE TRIGGER LogLoanUpdates
ON LoanApplications
AFTER UPDATE
AS
BEGIN
    INSERT INTO LoanAudit (LoanID, UpdateDate)
    SELECT LoanID, GETDATE()
    FROM inserted;
END;



Basic Examples

Below are practical examples using a LoanApplications table, similar to Spring Financial’s data.

1. Insert Sample Data

INSERT INTO LoanApplications (LoanID, Email, ApplicationDate, LoanAmount)
VALUES 
    ('L001', 'john.doe@springfinancial.ca', '2025-05-01', 5000.00),
    ('L002', 'alice.smith@gmail.com', '2025-05-02', 7500.50),
    ('L003', 'invalid.email@', '2025-05-03', 3000.75);

2. Query Valid Loans

SELECT *
FROM LoanApplications
WHERE LoanAmount > 4000;

3. Create a Stored Procedure

CREATE PROCEDURE GetHighValueLoans
    @MinAmount DECIMAL(10,2)
AS
BEGIN
    SELECT LoanID, Email, LoanAmount
    FROM LoanApplications
    WHERE LoanAmount >= @MinAmount;
END;
EXEC GetHighValueLoans @MinAmount = 5000.00;



Getting Started





Install MS SQL Server:





Download SQL Server Express (free) from Microsoft’s website.



Supports Windows; use Docker for Mac/Linux.



Set Up SQL Server Management Studio (SSMS):





Install SSMS for a GUI to manage databases.



Connect to your server using localhost or a server name.



Create Your First Database:

CREATE DATABASE MyFirstDB;



Run Your First Query:

USE MyFirstDB;
CREATE TABLE Test (ID INT, Name VARCHAR(50));
INSERT INTO Test VALUES (1, 'Test');
SELECT * FROM Test;



Best Practices







Practice



Description





Use Indexes



Create indexes on frequently queried columns (e.g., Email) to improve performance.





Normalize Data



Organize tables to reduce redundancy (e.g., separate Customers and Loans).





Secure Data



Use roles and permissions to restrict access, ensuring PIPEDA compliance.





Backup Regularly



Schedule backups to prevent data loss.





Write Clear T-SQL



Use comments and consistent formatting for maintainability.



Resources





Microsoft SQL Server Docs



W3Schools SQL Tutorial



SSMS Download
