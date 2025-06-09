/* ==============================================================================
   SQL Window Ranking Functions
-------------------------------------------------------------------------------
   These functions allow you to rank and order rows within a result set 
   without the need for complex joins or subqueries. They enable you to assign 
   unique or non-unique rankings, group rows into buckets, and analyze data 
   distributions on ordered data.

   Table of Contents:
     1. ROW_NUMBER
     2. RANK
     3. DENSE_RANK
     4. NTILE
     5. CUME_DIST
=================================================================================
*/

/* TASK 1:
   Rank Orders Based on Sales from Highest to Lowest
*/

select * from sales.orders; 

select orderid, productid, sales,
       row_number() over(order by sales desc) as sales_rank_row,
       rank() over(order by sales desc) as sales_rank_rank,
       dense_rank() over(order by sales desc) as sales_rank_dense
from sales.orders
order by sales desc;

/* TASK 2:
   Use Case | Top-N Analysis: Find the Highest Sale for Each Product
*/
select * from 
(
    select productid,
    sales,
    dense_rank() over(partition by productid order by sales desc) as rank_dense
    from sales.orders 
) t
where rank_dense = 1
order by productid asc , sales desc;

/* TASK 3:
   Use Case | Bottom-N Analysis: Find the Lowest 2 Customers Based on Their Total Sales
*/
select * from sales.orders;  
select * from
(
select *, 
dense_rank() over (order by sales asc) as sales_rank_dense
from sales.orders
) t where sales_rank_dense <= 2
order by sales asc;

/* TASK 4:
   Use Case | Assign Unique IDs to the Rows of the 'Order Archive'
*/
SELECT
    ROW_NUMBER() OVER (ORDER BY OrderID, OrderDate) AS UniqueID,
    *
FROM Sales.OrdersArchive;

/* TASK 5:
   Use Case | Identify Duplicates:
   Identify Duplicate Rows in 'Order Archive' and return a clean result without any duplicates
*/
SELECT *
FROM (
    SELECT
        ROW_NUMBER() OVER (PARTITION BY OrderID ORDER BY CreationTime DESC) AS rn,
        *
    FROM Sales.OrdersArchive
) AS UniqueOrdersArchive
WHERE rn = 1;

/* ============================================================
   SQL WINDOW RANKING | NTILE
   ============================================================ */

   /* TASK 6:
   Divide Orders into Groups Based on Sales
*/

select* from sales.orders; 

select orderid,
sales,
NTILE(1) over (order by sales) as onebucket,
NTILE(2) over (order by sales) as twobucket,
NTILE(3) over (order by sales) as threebucket,
NTILE(4) over (order by sales) as fourbuckets,
NTILE(2) over (partition by productid order by sales) as twobucketbyproducts
from sales.orders; 



/* TASK 7:
   Segment all Orders into 3 Categories: High, Medium, and Low Sales.
*/

SELECT
    OrderID,
    Sales,
    Buckets,
    CASE 
        WHEN Buckets = 1 THEN 'High'
        WHEN Buckets = 2 THEN 'Medium'
        WHEN Buckets = 3 THEN 'Low'
    END AS SalesSegmentations
FROM (
    SELECT
        OrderID,
        Sales,
        NTILE(3) OVER (ORDER BY Sales DESC) AS Buckets
    FROM Sales.Orders
) AS SalesBuckets;


/* TASK 8:
   Divide Orders into Groups for Processing
*/
SELECT 
    NTILE(5) OVER (ORDER BY OrderID) AS Buckets,
    *
FROM Sales.Orders;

/* ============================================================
   SQL WINDOW RANKING | CUME_DIST
   ============================================================ */

/* TASK 9:
   Find Products that Fall Within the Highest 40% of the Prices
*/
SELECT 
    Product,
    Price,
    DistRank,
    CONCAT(DistRank * 100, '%') AS DistRankPerc
FROM (
    SELECT
        Product,
        Price,
        CUME_DIST() OVER (ORDER BY Price DESC) AS DistRank
    FROM Sales.Products
) AS PriceDistribution
WHERE DistRank <= 0.4;

SELECT * FROM SALES.Products;
SELECT PERCENTILE_CONT(0.4) WITHIN GROUP (ORDER BY PRICE) OVER() AS PERCENTILE_40 FROM SALES.PRODUCTS;
