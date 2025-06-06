/* ==============================================================================
   SQL NULL Functions
-------------------------------------------------------------------------------
   This script highlights essential SQL functions for managing NULL values.
   It demonstrates how to handle NULLs in data aggregation, mathematical operations,
   sorting, and comparisons. These techniques help maintain data integrity 
   and ensure accurate query results.

   Table of Contents:
     1. Handle NULL - Data Aggregation
     2. Handle NULL - Mathematical Operators
     3. Handle NULL - Sorting Data
     4. NULLIF - Division by Zero
     5. IS NULL - IS NOT NULL
     6. LEFT ANTI JOIN
     7. NULLs vs Empty String vs Blank Spaces
===============================================================================
*/

/* ==============================================================================
   HANDLE NULL - DATA AGGREGATION
===============================================================================*/

/* TASK 1: 
   Find the average scores of the customers.
   Uses COALESCE to replace NULL Score with 0.*/

select * from sales.Customers;
select customerId,FirstName,Coalesce(Score,0) as total_score,
avg(coalesce(score,0)) over(order by customerid asc) as avg_score
from sales.Customers;

/* ==============================================================================
   HANDLE NULL - MATHEMATICAL OPERATORS
===============================================================================*/

/* TASK 2: 
   Display the full name of customers in a single field by merging their
   first and last names, and add 10 bonus points to each customer's score.*/

   Select concat(coalesce(FirstName,'') ,' ', Coalesce(LastName,'')) as full_name,
          (coalesce(score,0) + 10) as updated_score 
    from sales.customers;

/* ==============================================================================
   HANDLE NULL - SORTING DATA
===============================================================================*/

/* TASK 3: 
   Sort the customers from lowest to highest scores,
   with NULL values appearing last.
*/
select * from sales.Customers;
select * from sales.Customers order by Score asc;

select * from Sales.Customers
order by case when Score is NULL then 1 else 0 end,score; -- Important
-- or: 
select * from sales.customers
order by case when score is null then 1 else 0 end asc;


/* ==============================================================================
   NULLIF - DIVISION BY ZERO
===============================================================================*/

/* TASK 4: 
   Find the sales price for each order by dividing sales by quantity.
   Uses NULLIF to avoid division by zero.
*/

select * from sales.Orders;
select orderID,sales/nullif(quantity,0) as sales_price from sales.Orders;



/* ==============================================================================
   IS NULL - IS NOT NULL
===============================================================================*/

/* TASK 5: 
   Identify the customers who have no scores 
*/

select * from sales.Customers where score is null; 

/* TASK 6: 
   Identify the customers who have scores 
*/
SELECT *
FROM Sales.Customers
WHERE Score IS NOT NULL;

/* ==============================================================================
   LEFT ANTI JOIN
===============================================================================*/

/* TASK 7: 
   List all details for customers who have not placed any orders 
*/
select * from sales.Customers;
select * from sales.orders;

-- way 1:
select distinct customerId from sales.Customers
except 
select distinct customerID from sales.orders;
-- way 2:
select customerID from sales.Customers where CustomerID not IN 
(select distinct CustomerID from sales.orders); 

-- way 3: 
select c.customerID,o.orderID
from sales.Customers as c 
left join sales.Orders as o on c.CustomerID = o.CustomerID where o.OrderID is NULL;

/* ==============================================================================
   NULLs vs EMPTY STRING vs BLANK SPACES
===============================================================================*/

/* TASK 8: 
   Demonstrate differences between NULL, empty strings, and blank spaces 
*/

WITH Orders AS (
    SELECT 1 AS Id, 'A' AS Category UNION
    SELECT 2, NULL UNION
    SELECT 3, '' UNION
    SELECT 4, '  '
)
SELECT 
    *,
    DATALENGTH(Category) AS LenCategory,
    TRIM(Category) AS Policy1,
    NULLIF(TRIM(Category), '') AS Policy2,
    COALESCE(NULLIF(TRIM(Category), ''), 'unknown') AS Policy3
FROM Orders;

