USE  MyDatabase; -- Note: there is no keyword caled Database here, while using one.
GO
SELECT * FROM customers;

-- Order Data:
SELECT * FROM orders;

-- Checking few Columns:
SELECT id,first_name from customers;

/* WHERE CLAUSE */

-- Retrieve a CX with Score <> 0
SELECT * FROM customers WHERE score <> 0;

-- Retireve CX FROM GERMANY
SELECT * FROM customers WHERE country = 'GERMANY';

/* ORDER BY CLAUSE */

-- Order by Score:
SELECT * FROM customers ORDER BY score DESC;

-- Nested Order By:
Select * from customers order by score desc,first_name asc;

select * from customers order by country asc, score desc;


/* GROUP BY CLAUSE */

-- Find Total Scores for Each Country:

Select country, sum(score) as total_score 
from customers
group by country 
order by total_score Desc;

-- Avg Score and Total Customers for each Country:
Select country, AVG(score) as Avg_score, COUNT(DISTINCT first_name) as total_cx
from customers
group by country 
order by country Asc,Avg_score  Desc;

/* HAVING CLAUSE */
-- Avg Score and Total Customers for each Country, and also filter out those with avg score < = 450
Select country, AVG(score) as Avg_score, COUNT(DISTINCT first_name) as total_cx
from customers
group by country 
Having  AVG(score) >= 450
order by country Asc,Avg_score  Desc;

/* DISTINCT CLAUSE */ 

-- Get the unique list of all countries:
SELECT DISTINCT country FROM customers;


/* TOP CLAUSE */

SELECT TOP 3 * FROM customers;

Select top 3 id, first_name, country from customers;

-- Get the top 3 customers  based on score 

select TOP 3 first_name,score from customers order by score desc;

-- Get the lowest 3 customers  based on score 
select TOP 3 first_name,score from customers order by score ASC;

/* ORDER OF EXECUTION */ 
-- from
-- where
-- group by
-- select
-- having 
-- distinct 
-- top



