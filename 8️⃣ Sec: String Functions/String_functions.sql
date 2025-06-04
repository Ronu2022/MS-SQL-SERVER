/* ============================================================================== 
   SQL String Functions
-------------------------------------------------------------------------------
   This document provides an overview of SQL string functions, which allow 
   manipulation, transformation, and extraction of text data efficiently.

   Table of Contents:
     1. Manipulations
        - CONCAT
        - LOWER
        - UPPER
	- TRIM
	- REPLACE
     2. Calculation
        - LEN
     3. Substring Extraction
        - LEFT
        - RIGHT
        - SUBSTRING
================================================================================= */

/* ============================================================================== 
   CONCAT() - String Concatenation
=============================================================================== */
use MyDatabase;
go

select * from dbo.customers;
select concat(first_name,'<->', country) as concated from dbo.customers;


/* ============================================================================== 
   LOWER() & UPPER() - Case Transformation
=============================================================================== */
select * from dbo.customers;
select lower(first_name) as lowered_name from dbo.customers;
select upper(first_name)  as uppered_name from dbo.customers;

/* ============================================================================== 
-- TRIM() - Remove White Spaces
=============================================================================== */

-- Find customers whose first name contains leading or trailing spaces
select * from dbo.customers;
select first_name from dbo.customers
where len(first_name) - len(trim(first_name)) <> 0; 

/* ============================================================================== 
   REPLACE() - Replace or Remove old value with new one
=============================================================================== */
-- Remove dashes (-) from a date

select * from dbo.orders;

select order_date, replace(order_date,'-','/') as updated_date from 
dbo.orders; 

	
/* ============================================================================== 
   LEN() - String Length & Trimming
=============================================================================== */

-- Calculate the length of each customer's first name
select * from dbo.customers; 

select first_name, len(first_name) as length_of_characters,
len(first_name) - len(trim(first_name)) as no_of_white_spaces
from dbo.customers;


/* ============================================================================== 
   LEFT() & RIGHT() - Substring Extraction
=============================================================================== */

-- Retrieve the first two characters of each first name
select * from dbo.customers; 

select left(first_name,2) as first_2,
       right(first_name,2) as last_2,
       UPPER(LEFT(country,2)) as first_2_country,
       CONCAT(UPPER(LEFT(country,2)), ' | ', left(first_name,2), ' | ', right(first_name,2)) as combo
from dbo.customers;


-- Retrieve the last two characters of each first name
SELECT 
    first_name,
    RIGHT(first_name, 2) AS last_2_chars
FROM dbo.customers;

/* ============================================================================== 
   SUBSTRING() - Extracting Substrings
=============================================================================== */

-- Retrieve a list of customers' first names after removing the first character

select * from dbo.customers; 

select first_name,
SUBSTRING(trim(first_name),2,len(trim(first_name))-1)
from dbo.customers;

/* ==============================================================================
   NESTING FUNCTIONS
===============================================================================*/

-- Nesting
SELECT
first_name, 
UPPER(LOWER(first_name)) AS nesting
FROM customers

