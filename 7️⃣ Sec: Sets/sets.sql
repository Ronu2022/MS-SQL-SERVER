use SalesDB;
go

/* ==============================================================================
   SQL SET Operations
-------------------------------------------------------------------------------
   SQL set operations enable you to combine results from multiple queries
   into a single result set. This script demonstrates the rules and usage of
   set operations, including UNION, UNION ALL, EXCEPT, and INTERSECT.
   
   Table of Contents:
     1. SQL Operation Rules
     2. UNION
     3. UNION ALL
     4. EXCEPT
     5. INTERSECT
=================================================================================
*/

/* ==============================================================================
   RULES OF SET OPERATIONS
===============================================================================*/

/* RULE: Data Types
   The data types of columns in each query should match.
*/
-- no of columns must be same.
-- oder of columns must be the same.

select FirstName,
LastName from Sales.Customers;

Select FirstName, LastName from Sales.Employees;

select FirstName,
LastName from Sales.Customers
union
Select FirstName, LastName from Sales.Employees;


/* RULE: Data Types (Example)
   The data types of columns in each query should match.
*/
SELECT
    CustomerID,
    LastName
FROM Sales.Customers
UNION
SELECT
    FirstName,
    LastName
FROM Sales.Employees;

/* RULE: Column Order
   The order of the columns in each query must be the same.
*/
SELECT
    LastName,
    CustomerID
FROM Sales.Customers
UNION
SELECT
    EmployeeID,
    LastName
FROM Sales.Employees;

/* RULE: Column Aliases
   The column names in the result set are determined by the column names
   specified in the first SELECT statement.
*/
SELECT
    CustomerID AS ID,
    LastName AS Last_Name
FROM Sales.Customers
UNION
SELECT
    EmployeeID,
    LastName
FROM Sales.Employees;

/* RULE: Correct Columns
   Ensure that the correct columns are used to maintain data consistency.
*/
SELECT
    FirstName,
    LastName
FROM Sales.Customers
UNION
SELECT
    LastName,
    FirstName
FROM Sales.Employees;

/* ==============================================================================
   SETS: UNION, UNION ALL, EXCEPT, INTERSECT
===============================================================================*/

/* TASK 1: 
   Combine the data from Employees and Customers into one table using UNION 
*/

select FirstName,LastName
from Sales.Customers
union 
select FirstName,Lastname
from Sales.Employees;


/* TASK 2: 
   Combine the data from Employees and Customers into one table, including duplicates, using UNION ALL 
*/
select FirstName,LastName
from Sales.Customers
union all
select FirstName,Lastname
from Sales.Employees;

/* TASK 3: 
   Find employees who are NOT customers using EXCEPT 
*/

select * from Sales.Customers;
select * from Sales.Employees;

select FirstName, LastName
from Sales.Employees
except
select FirstName,LastName
from Sales.Customers;


/* TASK 4: 
   Find employees who are also customers using INTERSECT 
*/

select FirstName, LastName
from Sales.Employees
intersect 
select FirstName, LastName
from Sales.Customers;


/* TASK 5: 
   Combine order data from Orders and OrdersArchive into one report without duplicates 
*/
SELECT
    'Orders' AS SourceTable,
    OrderID,
    ProductID,
    CustomerID,
    SalesPersonID,
    OrderDate,
    ShipDate,
    OrderStatus,
    ShipAddress,
    BillAddress,
    Quantity,
    Sales,
    CreationTime
FROM Sales.Orders
UNION
SELECT
    'OrdersArchive' AS SourceTable,
    OrderID,
    ProductID,
    CustomerID,
    SalesPersonID,
    OrderDate,
    ShipDate,
    OrderStatus,
    ShipAddress,
    BillAddress,
    Quantity,
    Sales,
    CreationTime
FROM Sales.OrdersArchive
ORDER BY OrderID;

/* usage of set operators:
 -- delta deteection using Except: check project section Snowflake in Github!
