/* ==============================================================================
   SQL Data Definition Language (DDL)
-------------------------------------------------------------------------------
   This guide covers the essential DDL commands used for defining and managing
   database structures, including creating, modifying, and deleting tables.

   Table of Contents:
     1. CREATE - Creating Tables
     2. ALTER - Modifying Table Structure
     3. DROP - Removing Tables
=================================================================================
*/

/* ============================================================================== 
   CREATE
=============================================================================== */

/* Create a new table called persons 
   with columns: id, person_name, birth_date, and phone */
CREATE TABLE persons (
    id INT NOT NULL,
    person_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    phone VARCHAR(15) NOT NULL,
    CONSTRAINT pk_persons PRIMARY KEY (id)
);

-- adding primary key after creation
alter table persons
add constraint pk_person_b primary key (id); 

-- Dropping Constraint already created:
ALTER TABLE persons
DROP CONSTRAINT pk_persons;

/* RECALL : In snowflake, we dont have any contraint wrt primary key, though we have it, it is not enforceable,
infact it is there just for people to know.

-- we use windo function, merge for cleaner data.

CREATE OR REPLACE TABLE friends (
    id INT,
    name VARCHAR,
    phone VARCHAR
);


CREATE OR REPLACE TABLE new_friends (
    id INT,
    name VARCHAR,
    phone VARCHAR
);



INSERT INTO friends (id, name, phone)
VALUES 
    (1, 'Alice', '1234567890'),
    (2, 'Bob', '2345678901');


--  Data for new_friends (staging with duplicates)

INSERT INTO new_friends (id, name, phone)
VALUES 
    (1, 'Alice B', '8888888888'),  -- Same ID, updated name + phone
    (1, 'Alice C', '9999999999'),  -- Duplicate ID, another version
    (3, 'Charlie', '3456789012');  -- New person



-- Problem Statement:

You are a data engineer at a company. Your job is to:

✅ Clean and update the friends table using data from new_friends
Your MERGE must:
Update the row if the id already exists (like Alice, ID = 1)

Insert the row if the id doesn’t exist (like Charlie, ID = 3)

✅ But — from the new_friends table, only keep one row per id

You can decide the logic: pick the one with the highest phone number (for now)


-- code 

merge into friends as target
using 
(
    select id,name,phone, row_number() over (partition by id order by phone desc) as rn
    from new_friends qualify rn = 1
) as source on target.id = source.id
when matched then 
update
    set target.name = source.name,
        target.phone = source.phone
when not matched then
    insert(id,name,phone)
    values(source.id,source.name,source.phone)


-- now lets try making it within a procedure: 
-- first delete the records and re run the intial create statement.
-- so that it comes to square one again

CREATE OR REPLACE TABLE friends
(
    id INT,
    name VARCHAR,
    phone VARCHAR
);



CREATE OR REPLACE TABLE new_friends
(
    id INT,
    name VARCHAR,
    phone VARCHAR
);

INSERT INTO friends (id, name, phone)
VALUES 
    (1, 'Alice', '1234567890'),
    (2, 'Bob', '2345678901');

--  Data for new_friends (staging with duplicates)

INSERT INTO new_friends (id, name, phone)
VALUES 
    (1, 'Alice B', '8888888888'),  -- Same ID, updated name + phone
    (1, 'Alice C', '9999999999'),  -- Duplicate ID, another version
    (3, 'Charlie', '3456789012');  -- New person


// PROCEDURE:

Create or replace procedure proc_merge()
Returns string
language sql as
$$
    BEGIN
    merge into friends as target
    using
    (
        select id,name,phone, row_number() over (partition by id order by phone desc) as rn
        from new_friends qualify rn = 1 
    ) as source on  target.id = source.id
    when matched then
    update
        set  
            target.name = source.name,
            target.phone = source.phone
            
    when not matched then
        insert(id,name,phone) 
        values(source.id,source.name, source.phone);
    
    RETURN 'Insert and Merge Done';
    select * from 

END;
$$; 

// TASK:

Create or replace task task_name
warehouse = COMPUTE_WH
SCHEDULE = 'USING CRON * * * * * UTC'
AS CALL proc_merge();

// RESUMING TASK:

ALTER TASK task_name RESUME;
ALTER TASK task_name SUSPEND;
*/

-- Using Check Constraint

create table titles
(   entry_no int identity(1,2) primary key, -- identy -> similar to auto_incremenet , 1 = start, 2 is the jump
    title nvarchar(10) not null UNIQUE,
    retailprice smallmoney not null,
    check (retailprice > 0),
    discountprice smallmoney,
    check (discountprice < 20),
    publishdate date,
    check (publishdate >= '1900-10-01' and publishdate <= getdate()),
    publisher_state varchar(30),
    check (publisher_state IN ('WA,Odisha','Maharashtra'))
);


/* Re call snowflake 
create or replace sequence abc
start = 1
increment = 2

create or replace table def
(
    a int,
    b int
)
insert into(a,b) value (22,abc.nextval)


create or replace table def_b
(
    a int,
    b int identity (10,2)
)
*/






















/* ============================================================================== 
   ALTER
=============================================================================== */

-- Add a new column called email to the persons table
ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL;

-- Remove the column phone from the persons table
ALTER TABLE persons
DROP COLUMN phone;


/* ============================================================================== 
   DROP
=============================================================================== */

-- Delete the table persons from the database
DROP TABLE persons;
