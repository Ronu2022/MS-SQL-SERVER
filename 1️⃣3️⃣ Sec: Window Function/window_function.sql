/* ==============================================================================
   SQL Window Functions
-------------------------------------------------------------------------------
   SQL window functions enable advanced calculations across sets of rows 
   related to the current row without resorting to complex subqueries or joins.
   This script demonstrates the fundamentals and key clauses of window functions,
   including the OVER, PARTITION, ORDER, and FRAME clauses, as well as common rules 
   and a GROUP BY use case.

   Table of Contents:
     1. SQL Window Basics
     2. SQL Window OVER Clause
     3. SQL Window PARTITION Clause
     4. SQL Window ORDER Clause
     5. SQL Window FRAME Clause
     6. SQL Window Rules
     7. SQL Window with GROUP BY
=================================================================================
*/

/* ==============================================================================
   SQL WINDOW FUNCTIONS | BASICS
===============================================================================*/

/* TASK 1: 
   Calculate the Total Sales Across All Orders 
*/
SELECT
    SUM(Sales) AS Total_Sales
FROM Sales.Orders;

/* TASK 2: 
   Calculate the Total Sales for Each Product 
*/
SELECT 
    ProductID,
    SUM(Sales) AS Total_Sales
FROM Sales.Orders
GROUP BY ProductID;


/* ==============================================================================
   SQL WINDOW FUNCTIONS | OVER CLAUSE
===============================================================================*/

/* TASK 3: 
   Find the total sales across all orders,
   additionally providing details such as OrderID and OrderDate 
*/

select * from Sales.Orders;

SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    SUM(Sales) OVER () AS Total_Sales
FROM Sales.Orders;

select orderid,sales,
sum(Sales) over() as t_sales, -- mark this just gives the total sales same number for each row
sum(sales) over(order by orderid) as t_sales_1 -- once we give the order by Orderid kind of rolling total
from sales.Orders;


/* ==============================================================================
   SQL WINDOW FUNCTIONS | PARTITION CLAUSE
===============================================================================*/

/* TASK 4: 
   Find the total sales across all orders and for each product,
   additionally providing details such as OrderID and OrderDate 
*/
select * from Sales.Orders;

select ProductID,OrderID,OrderDate,sales,
sum(sales) Over(Partition by ProductID order by OrderID ASC) as total_Product_Sales_running,
sum(sales) over(partition by ProductID) as total_product_sales_cummulative
from sales.orders
order by Productid asc;


/* TASK 5: 
   Find the total sales across all orders, for each product,
   and for each combination of product and order status,
   additionally providing details such as OrderID and OrderDate 
*/

select * from sales.orders
order by ProductID ASC , OrderStatus ASC;

select productID, orderStatus, OrderID, OrderDate, 
sales,
sum(sales) over() as total_sales,
sum(sales) over(partition by ProductID,OrderStatus order by ProductID ASC,OrderStatus ASC)
as  part_sales
from sales.orders
order by productID aSC,OrderStatus ASC ;


/* ==============================================================================
   SQL WINDOW FUNCTIONS | ORDER CLAUSE
===============================================================================*/

/* TASK 6: 
   Rank each order by Sales from highest to lowest */
SELECT
    OrderID,
    OrderDate,
    Sales,
    RANK() OVER (ORDER BY Sales DESC) AS Rank_Sales
FROM Sales.Orders;



/* ==============================================================================
   SQL WINDOW FUNCTIONS | FRAME CLAUSE
===============================================================================*/

/* TASK 7: 
   Calculate Total Sales by Order Status for current and next two orders 
*/
select * from sales.orders;

select orderId,OrderStatus,OrderDate,sales,
sum(Sales) over (partition by OrderStatus Order by OrderDate ASC
ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) as sales_asked
from sales.orders
order by OrderStatus asc, OrderDate ASc;

/* TASK 8: 
   Calculate Total Sales by Order Status for current and previous two orders 
*/
select orderId,OrderStatus,OrderDate,sales,
sum(sales) over (partition by OrderStatus order by OrderDate Asc
rows between 2 preceding and current row) as sales_asked
from sales.orders
order by OrderStatus asc, OrderDate ASc;

/* TASK 9: 
   Calculate Total Sales by Order Status from previous two orders only 
*/

select * from sales.orders;

select orderId,OrderStatus,OrderDate,sales,
sum(Sales) over (partition by OrderStatus order by OrderDate ASC Rows 2 preceding ) as sales_asked
from sales.orders
order by OrderStatus asc, OrderDate ASc;

/* TASK 10: 
   Calculate cumulative Total Sales by Order Status up to the current order 
*/

select * from sales.orders;

select orderId, OrderStatus, OrderDate, sales,
sum(sales) over (partition by orderstatus order by orderDate Asc 
rows between unbounded preceding and current row) as asked_sales
from sales.orders
order by OrderStatus asc, OrderDate ASc;


/* TASK 11: 
   Calculate cumulative Total Sales by Order Status from the start to the current row 
*/
use  salesdb;
go
select * from sales.orders;
select 
    orderid, 
    productid,
    orderdate,
    sales,
    sum(sales) over(partition by orderstatus order by orderDate Asc
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as asked_sales
    from sales.orders;

   /* ==============================================================================
   SQL WINDOW FUNCTIONS | RULES
===============================================================================*/

/* RULE 1: 
   Window functions can only be used in SELECT or ORDER BY clauses 
*/
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (PARTITION BY OrderStatus) AS Total_Sales
FROM Sales.Orders
WHERE SUM(Sales) OVER (PARTITION BY OrderStatus) > 100; 
-- Invalid: window function in WHERE clause

/* RULE 2: 
   Window functions cannot be nested 
*/
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(SUM(Sales) OVER (PARTITION BY OrderStatus)) OVER (PARTITION BY OrderStatus) AS Total_Sales  -- Invalid nesting
FROM Sales.Orders;     


/* ==============================================================================
   SQL WINDOW FUNCTIONS | GROUP BY
===============================================================================*/

/* TASK 12: 
   Rank customers by their total sales 
*/
select * from sales.orders;
Select * from sales.customers;

select customerId,
sum(sales) as total_sales,
rank() over (order by sum(sales) Desc ) as rn
from sales.Orders
group by customerId
order by CustomerID;




