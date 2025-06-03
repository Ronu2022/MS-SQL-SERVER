use MyDatabase;
go
/* ==============================================================================
   SQL Joins 
-------------------------------------------------------------------------------
   This document provides an overview of SQL joins, which allow combining data
   from multiple tables to retrieve meaningful insights.

   Table of Contents:
     1. Basic Joins
        - INNER JOIN
        - LEFT JOIN
        - RIGHT JOIN
        - FULL JOIN
     2. Advanced Joins
        - LEFT ANTI JOIN
        - RIGHT ANTI JOIN
        - ALTERNATIVE INNER JOIN
        - FULL ANTI JOIN
        - CROSS JOIN
     3. Multiple Table Joins (4 Tables)
=================================================================================
*/

/* ============================================================================== 
   BASIC JOINS 
=============================================================================== */

-- No Join
/* Retrieve all data from customers and orders as separate results */
SELECT * FROM customers;
SELECT * FROM orders;


-- INNER JOIN
/* Get all customers along with their orders, 
   but only for customers who have placed an order */
select * from customers;
select * from orders;

select c.id,c.first_name,o.order_id from customers as c
inner join orders as o on c.id = o.customer_id;

- LEFT JOIN
/* Get all customers along with their orders, 
   including those without orders */

select c.*,coalesce(o.order_id,0) as order_id from customers as c
 left join orders as o on c.id = o.customer_id;

 -- RIGHT JOIN
/* Get all customers along with their orders, 
   including orders without matching customers */

   select coalesce(c.id,0000) as id,c.first_name,c.country,c.score
   from customers as c
   right join orders  as o on c.id = o.customer_id;

/* ============================================================================== 
   ADVANCED JOINS
=============================================================================== */

-- LEFT ANTI JOIN
/* Get all customers who haven't placed any order */
SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL

select c.id, c.first_name from
customers as c
left join orders as o
on c.id = o.customer_id where o.order_id is Null; 


-- RIGHT ANTI JOIN
/* Get all orders without matching customers */

SELECT * FROM customers;
SELECT * FROM orders;

select o.order_id, c.first_name from 
customers as c
right join orders as o on c.id = o.customer_id where c.first_name is null;

-- CROSS JOIN
/* Generate all possible combinations of customers and orders */
SELECT *
FROM customers
CROSS JOIN orders;

/* ============================================================================== 
   MULTIPLE TABLE JOINS (4 Tables)
=============================================================================== */

/* Task: Using SalesDB, Retrieve a list of all orders, along with the related customer, product, 
   and employee details. For each order, display:
   - Order ID
   - Customer's name
   - Product name
   - Sales amount
   - Product price
   - Salesperson's name */

USE SalesDB

SELECT 
    o.OrderID,
    o.Sales,
    c.FirstName AS CustomerFirstName,
    c.LastName AS CustomerLastName,
    p.Product AS ProductName,
    p.Price,
    e.FirstName AS EmployeeFirstName,
    e.LastName AS EmployeeLastName
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID;
