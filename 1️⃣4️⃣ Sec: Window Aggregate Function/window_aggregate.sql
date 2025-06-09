/* =============================================================================================================================================================
   SQL Window Aggregate Functions
-------------------------------------------------------------------------------
   These functions allow you to perform aggregate calculations over a set 
   of rows without the need for complex subqueries. They enable you to compute 
   counts, sums, averages, minimums, and maximums while still retaining access 
   to individual row details.

   Table of Contents:
    1. COUNT
    2. SUM
    3. AVG
    4. MAX / MIN
    5. ROLLING SUM & AVERAGE Use Case
=============================================================================================================================================================================================================================================
*/

/* ===========================================================================================================================================
   SQL WINDOW AGGREGATION | COUNT
   =========================================================================================================================================== */

/* TASK 1:
   Find the Total Number of Orders and the Total Number of Orders for Each Customer
*/

select * from sales.orders;

select
    customerid,
  orderid,orderdate,count(*) over() as [total orders],
  count(*) over(partition by customerid) as cx_order_count
from sales.orders;

/* TASK 2:
   - Find the Total Number of Customers
   - Find the Total Number of Scores for Customers
   - Find the Total Number of Countries
*/

select * from sales.Customers;

select 
    count(*) over() as total_customers_count,
    sum(coalesce(Score,0)) over() as total_scores,
    count( country) over( ) as total_countries_count
from sales.customers;

SELECT
    *,
    COUNT(*) OVER () AS TotalCustomersStar,
    COUNT(1) OVER () AS TotalCustomersOne,
    COUNT(Score) OVER() AS TotalScores,
    COUNT(Country) OVER() AS TotalCountries
FROM Sales.Customers;

-- COUNT(*) and COUNT(1) are functionally the same — they count total rows, even if there are NULLs.
-- COUNT(column) only counts rows where the column is not NULL.
-- In performance: COUNT(*), COUNT(1), and COUNT('anything constant')
      -- behave the same in SQL Server (the optimizer handles them similarly).

/* TASK 3:
   Check whether the table 'OrdersArchive' contains any duplicate rows
*/

select * from Sales.OrdersArchive;

select *, count(*) over(partition by orderId) as total_count -- this gives the count for each order id
from sales.OrdersArchive
order by OrderID ASC, creationtime Desc;


select * from 
(
   select *, count(*) over(partition by orderId) as total_count -- this gives the count for each order id
    from sales.OrdersArchive
    order by OrderID ASC, creationtime Desc 
)  t where total_count >=2; -- look this would throw error, because SQL server doesnb't allow order by inside a subquery
-- except used with top, offset etc.

select * from 
(
   select *, count(*) over(partition by orderId) as total_count -- this gives the count for each order id
    from sales.OrdersArchive
    --order by OrderID ASC, creationtime Desc 
)  t where total_count >=2; -- working fine.

/* ===========================================================================================================================================
   SQL WINDOW AGGREGATION | SUM
   ============================================================ */

/* TASK 4:
   - Find the Total Sales Across All Orders 
   - Find the Total Sales for Each Product
*/

select * from sales.orders;

select orderid,productid,sales, sum(sales) over() as total_sales,
sum(sales) over(partition by productid) as total_sales_product
from sales.orders
order by productid;

/* TASK 5:
   Find the Percentage Contribution of Each Product's Sales to the Total Sales
*/ 

select  orderid,productid,
sum(sales) over(partition by productid) as product_sales,
sum(sales) over() as total_sales,
(sum(sales) over(partition by productid) )/ (sum(sales) over()) as Percent_Contri
from sales.orders
order by productid asc;
-- Observe, in the above code, the results were coming as 0 , why ? because by default since both numerator and denominator
    -- is integer, by default sql server treats it be an integer div,so let's say the result was 0.2345, it skips the scale
    -- i.e after the deicmal and just returns the precision i.e. 0
    -- way forward, make the numerator or the denominator a float => will force the serverr to do divisions.

select  orderid,productid,
sum(sales) over(partition by productid) as product_sales,
sum(sales) over() as total_sales,
concat(round(cast(sum(sales) over(partition by productid) as FLOAT) / (sum(sales) over()),2), ' ', '%') as Percent_Contri
from sales.orders
order by productid asc;



/* ============================================================
   SQL WINDOW AGGREGATION | AVG
   ============================================================ */

/* TASK 6:
   - Find the Average Sales Across All Orders 
   - Find the Average Sales for Each Product
*/
select productid, sales, avg(sales) over() as avg_sales,
avg(sales) over(partition by productid) as avg_sales_product
from sales.orders order by productid asc;

select * from sales.orders;



/* TASK 7:
   Find the Average Scores of Customers
*/

select * from sales.Customers;

SELECT
    CustomerID,
    LastName,
    Score,
    COALESCE(Score, 0) AS CustomerScore,
    AVG(Score) OVER () AS AvgScore,
    AVG(COALESCE(Score, 0)) OVER () AS AvgScoreWithoutNull
FROM Sales.Customers;


/* TASK 8:
   Find all orders where Sales exceed the average Sales across all orders
*/
select * from sales.orders;

select * from 
(
select *,
avg(sales) over() as avg_sales_all_orders
from sales.orders
) as t where sales > avg_sales_all_orders;



/* ============================================================
   SQL WINDOW AGGREGATION | MAX / MIN
   ============================================================ */

/* TASK 9:
   Find the Highest and Lowest Sales across all orders
*/

select max(sales), min(sales) from sales.orders;


/* TASK 10:
   Find the Lowest Sales across all orders and by Product
*/

select *, min(sales) over() as min_sales,
min(sales) over(partition by productid) as min_sales_product
from sales.orders
order by productid asc;

/* TASK 11:
   Show the employees who have the highest salaries
*/

select * from sales.employees;

select * from  sales.employees where salary IN (select max(salary) over() from sales.employees);


/* TASK 12:
   Find the deviation of each Sale from the minimum and maximum Sales
*/

select orderid, productid, 
min(sales) over() as min_sales, 
max(sales) over() as max_sales, 
sales - min(sales) over() as  min_delta,
sales - max(sales) over() as max_dela
from sales.orders;



/* ============================================================
   Use Case | ROLLING SUM & AVERAGE
   ============================================================ */

/* TASK 13:
   Calculate the moving average of Sales for each Product over time
*/

select productid, orderdate,
avg(sales) over (partition by productid  order by orderdate asc) as moving_avg -- moving average
from sales.orders
order by productid asc, orderdate asc;


/* TASK 14:
   Calculate the moving average of Sales for each Product over time,
   include only the current order and  next order
*/
SELECT
    OrderID,
    ProductID,
    OrderDate,
    Sales,
    AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS RollingAvg
FROM Sales.Orders;



