/* =========================================================
   1. DDL - DATA DEFINITION LANGUAGE
   =========================================================

   DDL is used to DEFINE and MODIFY the STRUCTURE of
   database objects such as tables.

   Main DDL commands:
   1. CREATE  -> create database objects
   2. ALTER   -> modify structure
   3. DROP    -> remove structure
   4. TRUNCATE -> remove all data from a table

   Important terms:
   ATTRIBUTE -> Column
   TUPLE     -> Row
   RELATION  -> Table
*/


/* =========================================================
   1.1 CREATE
   =========================================================

   CREATE is used to create a new table.

   SYNTAX:

   CREATE TABLE table_name (
       column_name1 DATATYPE CONSTRAINT,
       column_name2 DATATYPE CONSTRAINT,
       ...
   );

   Common data types:
   INT / SERIAL -> Integer
   VARCHAR(n)   -> Variable-length string
   DATE         -> Date
   DECIMAL(p,s) -> Decimal number
   BOOLEAN      -> TRUE / FALSE
   TIMESTAMP    -> Date + time

   Common constraints:
   PRIMARY KEY -> Uniquely identifies each row
   NOT NULL    -> Value cannot be NULL
   UNIQUE      -> No duplicate values
   DEFAULT     -> Automatically supplies a value
   CHECK       -> Restricts allowed values
*/

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    date_of_birth DATE,
    balance DECIMAL(12, 2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


/* View all records */
SELECT * FROM customers;


/* =========================================================
   1.2 ALTER
   =========================================================

   ALTER is used to MODIFY THE STRUCTURE of an existing table.

   Common operations:
   a) ADD COLUMN
   b) DROP COLUMN
   c) RENAME COLUMN
   d) CHANGE DATA TYPE
   e) ADD CONSTRAINT
   f) DROP CONSTRAINT
*/


/* ---------------------------------------------------------
   a) ADD COLUMN
   ---------------------------------------------------------

   Adds a new column to an existing table.

   SYNTAX:
   ALTER TABLE table_name
   ADD COLUMN column_name DATATYPE;
*/

ALTER TABLE customers
ADD COLUMN phone VARCHAR(10);


/* ---------------------------------------------------------
   b) DROP COLUMN
   ---------------------------------------------------------

   Permanently removes a column and its data.

   SYNTAX:
   ALTER TABLE table_name
   DROP COLUMN column_name;
*/

ALTER TABLE customers
DROP COLUMN date_of_birth;


/* ---------------------------------------------------------
   c) RENAME COLUMN
   ---------------------------------------------------------

   Changes the name of an existing column.

   SYNTAX:
   ALTER TABLE table_name
   RENAME COLUMN old_name TO new_name;
*/

ALTER TABLE customers
RENAME COLUMN balance TO account_balance;


/* ---------------------------------------------------------
   d) CHANGE DATA TYPE
   ---------------------------------------------------------

   Changes the datatype of an existing column.

   SYNTAX:
   ALTER TABLE table_name
   ALTER COLUMN column_name TYPE new_datatype;
*/

ALTER TABLE customers
ALTER COLUMN account_balance TYPE DECIMAL(15,3);


/* ---------------------------------------------------------
   e) ADD CONSTRAINT
   ---------------------------------------------------------

   Adds a constraint after table creation.

   SYNTAX:
   ALTER TABLE table_name
   ADD CONSTRAINT constraint_name
   CHECK (condition);
*/

ALTER TABLE customers
ADD CONSTRAINT check_balance
CHECK (account_balance > 0);


/* ---------------------------------------------------------
   f) DROP CONSTRAINT
   ---------------------------------------------------------

   Removes an existing constraint.

   SYNTAX:
   ALTER TABLE table_name
   DROP CONSTRAINT constraint_name;
*/

ALTER TABLE customers
DROP CONSTRAINT check_balance;


/*
   PostgreSQL automatically creates the constraint name
   customers_email_key for the UNIQUE constraint on email.
*/

ALTER TABLE customers
DROP CONSTRAINT customers_email_key;


/* Remove DEFAULT constraint/behavior */
ALTER TABLE customers
ALTER COLUMN is_active DROP DEFAULT;


/* Allow NULL values in last_name */
ALTER TABLE customers
ALTER COLUMN last_name DROP NOT NULL;


/* =========================================================
   1.3 DROP
   =========================================================

   DROP removes the STRUCTURE itself.

   DROP TABLE:
   - Deletes the table
   - Deletes all data
   - Table no longer exists

   SYNTAX:
   DROP TABLE table_name;

   Safer version:
   DROP TABLE IF EXISTS table_name;
*/

DROP TABLE customers;

DROP TABLE IF EXISTS orders;


/* =========================================================
   1.4 TRUNCATE
   =========================================================

   TRUNCATE removes ALL ROWS from a table but keeps
   the table structure.

   SYNTAX:
   TRUNCATE TABLE table_name;

   Difference:

   DROP      -> Structure + data removed
   TRUNCATE  -> Data removed, structure remains
   DELETE    -> Selected/all rows removed
*/

TRUNCATE TABLE customers;


/*
   PostgreSQL SERIAL uses a sequence for auto-increment.
   To remove all rows AND restart the identity sequence:
   TRUNCATE TABLE customers RESTART IDENTITY;
*/


/* =========================================================
   2. DML - DATA MANIPULATION LANGUAGE
   =========================================================

   DML is used to INSERT, MODIFY and DELETE DATA
   inside an existing table.

   Main DML commands:
   1. INSERT
   2. UPDATE
   3. DELETE
*/


/* =========================================================
   2.1 INSERT
   =========================================================

   INSERT is used to add new rows to a table.

   Recommended syntax:

   INSERT INTO table_name
       (column1, column2, column3)
   VALUES
       (value1, value2, value3);

   Always specifying column names is safer because:
   - You don't have to remember exact column order
   - You can omit columns having DEFAULT values
   - Your query is easier to understand
*/


INSERT INTO customers
    (first_name, last_name, email, account_balance, is_active)
VALUES
    ('Aarav', 'Sharma', 'aarav.sharma@gmail.com', 12500.50, TRUE);


/* ---------------------------------------------------------
   INSERT with specific columns
   --------------------------------------------------------- */

INSERT INTO customers
    (first_name, last_name, email, account_balance, is_active)
VALUES
    ('Aarav', 'Chauhan', 'aarav.chauhan@gmail.com', 12500.50, TRUE);


/* ---------------------------------------------------------
   INSERT with manually specified customer_id
   ---------------------------------------------------------

   Normally SERIAL automatically generates customer_id.

   Manual insertion is possible:

   INSERT INTO table_name
       (customer_id, column2, column3)
   VALUES
       (102, value2, value3);
*/

INSERT INTO customers
    (customer_id, first_name, last_name, email,
     account_balance, is_active)
VALUES
    (102, 'Shubham', 'Thakur',
     'shubham.thakur@gmail.com', 12500.50, TRUE);


/* ---------------------------------------------------------
   INSERT MULTIPLE ROWS
   ---------------------------------------------------------

   Multiple records can be inserted using one INSERT.

   SYNTAX:

   INSERT INTO table_name (column1, column2, ...)
   VALUES
       (value1, value2, ...),
       (value1, value2, ...),
       (value1, value2, ...);
*/

INSERT INTO customers
    (first_name, last_name, email, account_balance, is_active)
VALUES
    ('Aarav', 'Sharma', 'aarav.sharma@gmail.com', 12500.50, TRUE),
    ('Priya', 'Patel', 'priya.patel@gmail.com', 8500.00, TRUE),
    ('Rahul', 'Verma', 'rahul.verma@yahoo.com', 3200.75, TRUE),
    ('Sneha', 'Reddy', 'sneha.reddy@gmail.com', 15750.25, TRUE),
    ('Arjun', 'Mehta', 'arjun.mehta@outlook.com', 450.00, TRUE),
    ('Ananya', 'Iyer', 'ananya.iyer@gmail.com', 22000.00, TRUE),
    ('Vikram', 'Nair', 'vikram.nair@yahoo.com', 6750.80, TRUE),
    ('Kavya', 'Rao', 'kavya.rao@gmail.com', 980.50, TRUE),
    ('Rohan', 'Verma', 'rohan.verma@gmail.com', 18500.00, FALSE),
    ('Neha', 'Kapoor', 'neha.kapoor@outlook.com', 7600.40, TRUE),
    ('Aditya', 'Joshi', 'aditya.joshi@gmail.com', 31500.00, TRUE),
    ('Pooja', 'Desai', 'pooja.desai@yahoo.com', 1250.00, FALSE),
    ('Karan', 'Malhotra', 'karan.malhotra@gmail.com', 42000.75, TRUE),
    ('Meera', 'Krishnan', 'meera.krishnan@gmail.com', 5600.00, TRUE),
    ('Sanjay', 'Kumar', 'sanjay.kumar@outlook.com', 250.25, FALSE),
    ('Divya', 'Menon', 'divya.menon@gmail.com', 11200.00, TRUE),
    ('Manish', 'Agarwal', 'manish.agarwal@yahoo.com', 8900.90, TRUE),
    ('Ishita', 'Singh', 'ishita.singh@gmail.com', 1500.00, TRUE),
    ('Nikhil', 'Bhat', 'nikhil.bhat@gmail.com', 27500.00, TRUE),
    ('Swati', 'Shah', 'swati.shah@outlook.com', 4300.60, FALSE),
    ('Abhishek', 'Gupta', 'abhishek.gupta@gmail.com', 19500.00, TRUE),
    ('Riya', 'Choudhary', 'riya.choudhary@yahoo.com', 7200.00, TRUE),
    ('Varun', 'Saxena', 'varun.saxena@gmail.com', 36000.50, TRUE),
    ('Shreya', 'Pillai', 'shreya.pillai@gmail.com', 6400.25, TRUE),
    ('Deepak', 'Mishra', 'deepak.mishra@outlook.com', 1100.00, FALSE);


SELECT * FROM customers;


/* =========================================================
   2.2 UPDATE
   =========================================================

   UPDATE modifies existing rows.

   SYNTAX:

   UPDATE table_name
   SET column1 = value1,
       column2 = value2
   WHERE condition;

   VERY IMPORTANT:
   Always be careful with WHERE.

   Without WHERE:
   UPDATE affects EVERY ROW.
*/


/* Update one customer's email */
UPDATE customers
SET email = 'default@yahoo.com'
WHERE customer_id = 500;


/* Update balance using conditions */
UPDATE customers
SET account_balance = 14752
WHERE first_name = 'Aarav'
  AND last_name = 'Chauhan';


/* Update multiple columns */
UPDATE customers
SET account_balance = 15000,
    email = 'aarav@yahoo.com'
WHERE first_name = 'Aarav'
  AND last_name = 'Chauhan';


/* ---------------------------------------------------------
   UPDATE using existing column value
   ---------------------------------------------------------

   Increase everyone's balance by 10%.

   account_balance * 1.1
   means:
   old balance + 10%
*/

UPDATE customers
SET account_balance = account_balance * 1.1;


/* Check the updated record */
SELECT *
FROM customers
WHERE first_name = 'Aarav'
  AND last_name = 'Chauhan';


/* =========================================================
   2.3 DELETE
   =========================================================

   DELETE removes rows from a table.

   SYNTAX:

   DELETE FROM table_name
   WHERE condition;

   IMPORTANT:
   DELETE without WHERE removes ALL rows.
*/


/* First check which rows will be deleted */
SELECT *
FROM customers
WHERE last_name = 'Saxena';


/* Delete customers whose last name is Saxena */
DELETE FROM customers
WHERE last_name = 'Saxena';


/* Delete inactive customers having balance < 3000 */
DELETE FROM customers
WHERE is_active = FALSE
  AND account_balance < 3000;


/* =========================================================
   3. SELECT, WHERE, ORDER BY, DISTINCT, LIMIT
   =========================================================

   SELECT is used to RETRIEVE DATA from a table.

   Basic syntax:

   SELECT column1, column2
   FROM table_name
   WHERE condition
   ORDER BY column
   LIMIT number;
*/


/* =========================================================
   3.1 SELECT ALL COLUMNS
   =========================================================

   * means ALL columns.
*/

SELECT *
FROM customers;


/* =========================================================
   3.1.2 SELECT SPECIFIC COLUMNS
   =========================================================

   Instead of *, we can specify required columns.

   SYNTAX:

   SELECT column1, column2
   FROM table_name;
*/


SELECT first_name, last_name, account_balance
FROM customers;


/* ---------------------------------------------------------
   CONCATENATING COLUMNS
   ---------------------------------------------------------

   || is the string concatenation operator in PostgreSQL.

   first_name || ' ' || last_name

   combines:

   Abhimanyu + space + Saklani

   AS is used to create a COLUMN ALIAS.

   SYNTAX:

   SELECT expression AS alias_name
   FROM table_name;
*/

SELECT
    first_name || ' ' || last_name AS name
FROM customers;


/* =========================================================
   3.1.3 WHERE
   =========================================================

   WHERE filters rows based on a condition.

   SYNTAX:

   SELECT columns
   FROM table_name
   WHERE condition;

   Common operators:

   =       Equal
   <> / != Not equal
   >       Greater than
   <       Less than
   >=      Greater than or equal
   <=      Less than or equal

   Logical operators:

   AND
   OR
   NOT
*/


SELECT
    first_name || ' ' || last_name AS name,
    account_balance
FROM customers
WHERE is_active = TRUE
  AND account_balance > 20000;


/* =========================================================
   3.1.4 BETWEEN
   =========================================================

   BETWEEN checks whether a value falls within a range.

   SYNTAX:

   WHERE column_name BETWEEN lower_value AND upper_value;

   IMPORTANT:
   BETWEEN is INCLUSIVE.

   Example:
   BETWEEN 20000 AND 100000

   means >= 20000 AND <= 100000.
*/

SELECT
    first_name || ' ' || last_name AS name,
    account_balance
FROM customers
WHERE is_active = TRUE
  AND account_balance BETWEEN 20000 AND 100000;


/* =========================================================
   3.1.5 IS NULL / IS NOT NULL
   =========================================================

   NULL means "missing/unknown value".

   Do NOT use:

   WHERE column = NULL

   Use:

   WHERE column IS NULL

   or:

   WHERE column IS NOT NULL
*/


/* Find customers whose DOB is missing */
SELECT *
FROM customers
WHERE date_of_birth IS NULL;


/* Find customers whose DOB is available */
SELECT *
FROM customers
WHERE date_of_birth IS NOT NULL;


/* =========================================================
   3.1.6 LIKE
   =========================================================

   LIKE is used for PATTERN MATCHING.

   Wildcards:

   % -> Zero or more characters
   _ -> Exactly one character

   Examples:

   'A%'   -> Starts with A
   '%a'   -> Ends with a
   '%ar%' -> Contains "ar"
   '_a%'  -> Second character is 'a'
*/


SELECT *
FROM customers
WHERE first_name LIKE '_a%';


/* =========================================================
   3.2 ORDER BY
   =========================================================

   ORDER BY is used to SORT query results.

   SYNTAX:

   SELECT columns
   FROM table_name
   ORDER BY column_name ASC;

   ASC  -> Ascending (default)
   DESC -> Descending

   Multiple columns can be used.

   First sort by first_name.
   If two names are same, sort their last_name.
*/

SELECT *
FROM customers
ORDER BY first_name ASC,
         last_name DESC;


/* =========================================================
   3.3 DISTINCT
   =========================================================

   DISTINCT removes duplicate values from the result.

   SYNTAX:

   SELECT DISTINCT column_name
   FROM table_name;
*/


SELECT DISTINCT first_name
FROM customers;


/*
   DISTINCT can also work with multiple columns.

   The combination of columns must be unique.
*/

SELECT DISTINCT first_name, last_name
FROM customers;


/* =========================================================
   3.4 LIMIT
   =========================================================

   LIMIT restricts the number of rows returned.

   SYNTAX:

   SELECT columns
   FROM table_name
   LIMIT number;
*/

SELECT *
FROM customers
LIMIT 3;


/*
===========================================================
QUICK REVISION
===========================================================

DDL
----
CREATE      -> Create structure
ALTER       -> Modify structure
DROP        -> Delete structure
TRUNCATE    -> Delete all rows, keep structure

DML
----
INSERT      -> Add rows
UPDATE      -> Modify rows
DELETE      -> Remove rows

DQL
----
SELECT      -> Retrieve data

IMPORTANT SELECT CLAUSES
------------------------
WHERE       -> Filter rows
ORDER BY    -> Sort rows
DISTINCT    -> Remove duplicates
LIMIT       -> Restrict number of rows

PATTERN MATCHING
----------------
LIKE
%           -> 0 or more characters
_           -> Exactly 1 character

NULL
----
IS NULL
IS NOT NULL

CONSTRAINTS
-----------
PRIMARY KEY
NOT NULL
UNIQUE
DEFAULT
CHECK

KEY DIFFERENCE
--------------
DROP      -> Deletes table structure + data
TRUNCATE  -> Deletes all rows, keeps table
DELETE    -> Deletes selected rows (or all with no WHERE)
*/
-- 4. AGGREGATE FUNCTIONS
/*

# CREATE TWO MORE TABLES FOR AGGREGATE FUNCTIONS & JOINS

Existing table:
customers
|
| customer_id
↓
orders
|
| product_id
↓
products

RELATIONSHIP:

customers.customer_id → orders.customer_id
products.product_id   → orders.product_id
*/

-- =========================================================
-- 4.1 CREATE PRODUCTS TABLE
-- =========================


CREATE TABLE products (
product_id SERIAL PRIMARY KEY,
product_name VARCHAR(100) NOT NULL,
category VARCHAR(50),
price DECIMAL(10,2) NOT NULL
);

/* Insert sample products */

INSERT INTO products
(product_name, category, price)
VALUES
('Laptop', 'Electronics', 65000.00),
('Mouse', 'Electronics', 1200.00),
('Keyboard', 'Electronics', 2500.00),
('Headphones', 'Electronics', 3500.00),
('Office Chair', 'Furniture', 8500.00),
('Desk', 'Furniture', 12000.00),
('Notebook', 'Stationery', 250.00),
('Pen Set', 'Stationery', 150.00);

/* View products */

SELECT *
FROM products;

/* =========================================================
4.2 CREATE ORDERS TABLE
=======================

This table stores customer orders.

order_id       -> Unique order
customer_id    -> Customer who placed the order
product_id     -> Product purchased
quantity       -> Number of products purchased
order_date     -> Date of order

FOREIGN KEY creates a relationship between tables.

customer_id references customers.customer_id
product_id references products.product_id
*/

CREATE TABLE orders (
order_id SERIAL PRIMARY KEY,
customer_id INT NOT NULL,
product_id INT NOT NULL,
quantity INT NOT NULL,
order_date DATE DEFAULT CURRENT_DATE,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);


/* =========================================================
FOREIGN KEY SYNTAX
==================

FOREIGN KEY (column_name)
REFERENCES parent_table(parent_column);

Example:

FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

This means:

orders.customer_id
↓
customers.customer_id

The value in orders.customer_id must exist
in customers.customer_id.
*/

/* Insert sample orders */

INSERT INTO orders
(customer_id, product_id, quantity, order_date)
VALUES
(1, 1, 1, '2026-08-01'),
(1, 2, 2, '2026-08-02'),
(2, 3, 1, '2026-08-03'),
(2, 5, 1, '2026-08-04'),
(3, 4, 2, '2026-08-05'),
(3, 7, 5, '2026-08-06'),
(4, 1, 1, '2026-08-07'),
(5, 6, 1, '2026-08-08'),
(6, 8, 3, '2026-08-09'),
(7, 2, 2, '2026-08-10'),
(8, 5, 1, '2026-08-11'),
(9, 3, 2, '2026-08-12'),
(10, 4, 1, '2026-08-13'),
(11, 1, 1, '2026-08-14'),
(12, 7, 10, '2026-08-15');

SELECT *
FROM orders;

/* =========================================================
4. AGGREGATE FUNCTIONS
======================

Aggregate functions perform calculations on
MULTIPLE ROWS and return ONE RESULT.

Main aggregate functions:

COUNT() -> Counts rows/values
SUM()   -> Calculates total
AVG()   -> Calculates average
MIN()   -> Finds minimum
MAX()   -> Finds maximum
*/

/* =========================================================
4.1 COUNT()
===========

COUNT() counts rows or non-NULL values.

SYNTAX:

SELECT COUNT(column_name)
FROM table_name;

COUNT(*) counts ALL rows.
*/

/* Count total customers */

SELECT COUNT(*)
FROM customers;

/* Count customers having an email */

SELECT COUNT(email)
FROM customers;

/*
COUNT(*) vs COUNT(column)

COUNT(*)        -> Counts every row
COUNT(column)  -> Counts only NON-NULL values
*/

/* Count total orders */

SELECT COUNT(*)
FROM orders;

/* =========================================================
4.2 SUM()
=========

SUM() calculates the total of a numeric column.

SYNTAX:

SELECT SUM(column_name)
FROM table_name;
*/

/* Total quantity of products ordered */

SELECT SUM(quantity)
FROM orders;

/* =========================================================
4.3 AVG()
=========

AVG() calculates the average of a numeric column.

SYNTAX:

SELECT AVG(column_name)
FROM table_name;
*/

/* Average product price */

SELECT AVG(price)
FROM products;

/* =========================================================
4.4 MIN()
=========

MIN() returns the smallest value.

SYNTAX:

SELECT MIN(column_name)
FROM table_name;
*/

/* Cheapest product */

SELECT MIN(price)
FROM products;

/* =========================================================
4.5 MAX()
=========

MAX() returns the largest value.

SYNTAX:

SELECT MAX(column_name)
FROM table_name;
*/

/* Most expensive product */

SELECT MAX(price)
FROM products;

/* =========================================================
4.6 USING MULTIPLE AGGREGATE FUNCTIONS
======================================

Multiple aggregate functions can be used
in the same SELECT statement.
*/

SELECT
COUNT(*) AS total_products,
SUM(price) AS total_price,
AVG(price) AS average_price,
MIN(price) AS cheapest_price,
MAX(price) AS most_expensive_price
FROM products;

/* =========================================================
5. GROUP BY
===========

GROUP BY groups rows having the SAME VALUE.

It is commonly used with aggregate functions.

SYNTAX:

SELECT column_name, AGGREGATE_FUNCTION(column)
FROM table_name
GROUP BY column_name;
*/

/* Count products in each category */

SELECT
category,
COUNT(*) AS product_count
FROM products
GROUP BY category;

/* Average product price for each category */

SELECT
category,
AVG(price) AS average_price
FROM products
GROUP BY category;

/* Total products ordered by each customer */

SELECT
customer_id,
SUM(quantity) AS total_quantity
FROM orders
GROUP BY customer_id;

/*
Think of GROUP BY like this:

category
↓
Electronics → 4 products
Furniture   → 2 products
Stationery  → 2 products
*/

/* =========================================================
6. HAVING
=========

HAVING filters GROUPS.

WHERE filters INDIVIDUAL ROWS.

HAVING filters the result AFTER GROUP BY.

SYNTAX:

SELECT column_name, AGGREGATE_FUNCTION(column)
FROM table_name
GROUP BY column_name
HAVING condition;
*/

/* Categories having more than 2 products */

SELECT
category,
COUNT(*) AS product_count
FROM products
GROUP BY category
HAVING COUNT(*) > 2;

/* Customers who ordered more than 2 products */

SELECT
customer_id,
SUM(quantity) AS total_quantity
FROM orders
GROUP BY customer_id
HAVING SUM(quantity) > 2;

# /*

# WHERE vs HAVING

## WHERE

Filters ROWS before grouping.

## HAVING

Filters GROUPS after GROUP BY.

Example:

SELECT category, AVG(price)
FROM products
WHERE price > 1000
GROUP BY category
HAVING AVG(price) > 5000;

Execution concept:

FROM
↓
WHERE
↓
GROUP BY
↓
HAVING
↓
SELECT
↓
ORDER BY
*/

/* =========================================================
7. JOINS
========

JOIN is used to combine data from MULTIPLE TABLES.

We have:

customers
products
orders

orders acts as the connecting table.

customers
|
| customer_id
|
orders
|
| product_id
|
products
*/

/* =========================================================
7.1 INNER JOIN
==============

Returns ONLY rows that have matching values
in BOTH tables.

SYNTAX:

SELECT columns
FROM table1
INNER JOIN table2
ON table1.column = table2.column;
*/

/* Get orders with customer names */

SELECT
orders.order_id,
customers.first_name,
customers.last_name,
orders.quantity
FROM orders
INNER JOIN customers
ON orders.customer_id = customers.customer_id;

/* Get order + customer + product information */

SELECT
orders.order_id,
customers.first_name || ' ' || customers.last_name AS customer_name,
products.product_name,
orders.quantity,
products.price
FROM orders
INNER JOIN customers
ON orders.customer_id = customers.customer_id
INNER JOIN products
ON orders.product_id = products.product_id;

/* =========================================================
7.2 LEFT JOIN
=============

Returns:

ALL rows from the LEFT table
+
matching rows from the RIGHT table.

If there is no match, NULL is returned
for the right table.

SYNTAX:

SELECT columns
FROM table1
LEFT JOIN table2
ON table1.column = table2.column;
*/

/* Show ALL customers, even if they have no orders */

SELECT
customers.customer_id,
customers.first_name,
orders.order_id
FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.customer_id;

/*
LEFT JOIN is useful when the question says:

"Show ALL customers..."

even if they don't have an order.
*/

/* =========================================================
7.3 RIGHT JOIN
==============

Returns:

ALL rows from the RIGHT table
+
matching rows from the LEFT table.

SYNTAX:

SELECT columns
FROM table1
RIGHT JOIN table2
ON table1.column = table2.column;
*/

/* Show ALL products, even if nobody ordered them */

SELECT
products.product_id,
products.product_name,
orders.order_id
FROM orders
RIGHT JOIN products
ON orders.product_id = products.product_id;

/* =========================================================
7.4 FULL OUTER JOIN
===================

Returns:

ALL matching rows
+
unmatched rows from LEFT table
+
unmatched rows from RIGHT table.

SYNTAX:

SELECT columns
FROM table1
FULL OUTER JOIN table2
ON table1.column = table2.column;
*/

SELECT
customers.customer_id,
customers.first_name,
orders.order_id
FROM customers
FULL OUTER JOIN orders
ON customers.customer_id = orders.customer_id;

/* =========================================================
7.5 CROSS JOIN
==============

CROSS JOIN produces every possible combination
of rows between two tables.

If:

Table A = 3 rows
Table B = 4 rows

Result = 3 × 4 = 12 rows.

SYNTAX:

SELECT *
FROM table1
CROSS JOIN table2;
*/

SELECT
customers.first_name,
products.product_name
FROM customers
CROSS JOIN products;

/* =========================================================
7.6 SELF JOIN
=============

SELF JOIN means joining a table with ITSELF.

Example use cases:

* Employee → Manager
* Employee → Employee
* Friend relationships
* Hierarchical data

It requires table ALIASES.
*/

/*
Example syntax:

SELECT a.column, b.column
FROM table_name a
JOIN table_name b
ON a.some_column = b.some_column;
*/

/* =========================================================
8. JOINS + AGGREGATE FUNCTIONS
==============================

This is VERY IMPORTANT for interviews.

We can combine:

JOIN

* GROUP BY
* Aggregate functions
* HAVING
  */

/* Total quantity ordered by each customer */

SELECT
c.customer_id,
c.first_name || ' ' || c.last_name AS customer_name,
SUM(o.quantity) AS total_items
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY
c.customer_id,
c.first_name,
c.last_name;

/* =========================================================
9. CALCULATE TOTAL ORDER VALUE
==============================

Order value:

quantity × price

We can calculate this using data from
two different tables.
*/

SELECT
o.order_id,
p.product_name,
o.quantity,
p.price,
o.quantity * p.price AS order_value
FROM orders o
INNER JOIN products p
ON o.product_id = p.product_id;

/* =========================================================
10. CUSTOMER TOTAL SPENDING
===========================

JOIN customers + orders + products

Then:

SUM(quantity * price)

gives total amount spent by each customer.
*/

SELECT
c.customer_id,
c.first_name || ' ' || c.last_name AS customer_name,
SUM(o.quantity * p.price) AS total_spending
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
INNER JOIN products p
ON o.product_id = p.product_id
GROUP BY
c.customer_id,
c.first_name,
c.last_name;

/* =========================================================
11. HAVING WITH JOIN
====================

Find customers whose total spending
is greater than 20,000.
*/

SELECT
c.customer_id,
c.first_name || ' ' || c.last_name AS customer_name,
SUM(o.quantity * p.price) AS total_spending
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
INNER JOIN products p
ON o.product_id = p.product_id
GROUP BY
c.customer_id,
c.first_name,
c.last_name
HAVING SUM(o.quantity * p.price) > 20000;