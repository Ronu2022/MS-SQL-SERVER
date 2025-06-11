/* ==============================================================================
   SQL Window Value Functions
-------------------------------------------------------------------------------
   These functions let you reference and compare values from other rows 
   in a result set without complex joins or subqueries, enabling advanced 
   analysis on ordered data.

   Table of Contents:
     1. LEAD
     2. LAG
     3. FIRST_VALUE
     4. LAST_VALUE
=================================================================================
*/

/* ============================================================
   SQL WINDOW VALUE | LEAD, LAG
   ============================================================ */

/* TASK 1:
   Analyze the Month-over-Month Performance by Finding the Percentage Change in Sales
   Between the Current and Previous Months
*/

select * from Sales.Orders;

-- my way:
select  format(month_trunc,'MMM') as month_name,
        total_sales as current_total_sales,
        Lag(total_sales,1) over( order by month_trunc asc )  as previous_month_sales,
        total_sales - Lag(total_sales,1) over(order by month_trunc asc) as sales_diff,
        CONCAT(
                (cast((total_sales - Lag(total_sales,1) over(order by month_trunc asc)) as float)/Lag(total_sales,1) over( order by month_trunc asc )) * 100,' ','%')
     as percent_dif

from
(
    select 
    datetrunc(month,orderdate) as month_trunc,
    sum(sales) as total_sales
    from sales.orders
    group by datetrunc(month,orderdate)

) as t;

-- way 2:
SELECT
    *,
    CurrentMonthSales - PreviousMonthSales AS MoM_Change,
    ROUND(
        CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT)
        / PreviousMonthSales * 100, 1
    ) AS MoM_Perc
FROM (
    SELECT
        MONTH(OrderDate) AS OrderMonth,
        SUM(Sales) AS CurrentMonthSales,
        LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) AS PreviousMonthSales
    FROM Sales.Orders
    GROUP BY MONTH(OrderDate)
) AS MonthlySales;


/* TASK 2:
   Customer Loyalty Analysis - Rank Customers Based on the Average Days Between Their Orders
*/

select * From Sales.Orders;

-- My way:
with date_diff_cte as
(
select 
   customerid,
   orderdate as current_order_Date,
   lead(orderdate) over(partition by customerid order by orderdate asc) as next_order_date,
   datediff(day,orderdate,lead(orderdate) over(partition by customerid order by orderdate asc)) as day_diff
from sales.orders
--order by customerID ASC ,OrderDate ASC;
) 
select customerid, avg(day_diff) as avg_days,
dense_rank() over(order by avg(day_diff) ASC) as rank_dense
from date_diff_cte
where day_diff is not null
group by customerid
order by dense_rank() over(order by avg(day_diff) ASC);


-- 2nd Way:
SELECT
    CustomerID,
    AVG(DaysUntilNextOrder) AS AvgDays,
    RANK() OVER (ORDER BY COALESCE(AVG(DaysUntilNextOrder), 999999)) AS RankAvg
FROM (
    SELECT
        OrderID,
        CustomerID,
        OrderDate AS CurrentOrder,
        LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS NextOrder,
        DATEDIFF(
            day,
            OrderDate,
            LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)
        ) AS DaysUntilNextOrder
    FROM Sales.Orders
) AS CustomerOrdersWithNext
GROUP BY CustomerID;


/* ============================================================
   SQL WINDOW VALUE | FIRST & LAST VALUE
   ============================================================ */

/* TASK 3:
   Find the Lowest and Highest Sales for Each Product,
   and determine the difference between the current Sales and the lowest Sales for each Product.
*/

Select * from Sales.Orders;

select productID,
       FIRST_VALUE(Sales) over(partition by productid order by sales desc) as highest_sales,
       FIRST_VALUE(Sales) over(partition by productid order by sales ASC) as  lowest_sales,
       sales,
       sales - FIRST_VALUE(Sales) over(partition by productid order by sales ASC) as sales_diff
FROM Sales.Orders;


