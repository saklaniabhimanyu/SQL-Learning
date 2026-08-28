# Day 1 — SQL Fundamentals

Day 1 covers the core SQL concepts required to work with relational databases and write basic-to-intermediate SQL queries.

**Database:** PostgreSQL

---

# 📚 Topics Covered

* SQL & Relational Database Fundamentals
* Tables, Rows & Columns
* Data Types
* Constraints
* DDL — Data Definition Language

  * `CREATE`
  * `ALTER`
  * `DROP`
  * `TRUNCATE`
* DML — Data Manipulation Language

  * `INSERT`
  * `UPDATE`
  * `DELETE`
* DQL — Data Query Language

  * `SELECT`
* Filtering

  * `WHERE`
  * `AND`
  * `OR`
  * `BETWEEN`
  * `IN`
  * `IS NULL`
  * `IS NOT NULL`
  * `LIKE`
* Column Aliases
* String Concatenation
* Sorting

  * `ORDER BY`
* `DISTINCT`
* `LIMIT`
* Aggregate Functions

  * `COUNT()`
  * `SUM()`
  * `AVG()`
  * `MIN()`
  * `MAX()`
* `GROUP BY`
* `HAVING`
* Primary Keys
* Foreign Keys
* Joins

  * `INNER JOIN`
  * `LEFT JOIN`
  * `RIGHT JOIN`
  * `FULL OUTER JOIN`
  * `CROSS JOIN`
  * `SELF JOIN`

---

# 1. What is SQL?

**SQL (Structured Query Language)** is a language used to communicate with relational databases.

SQL can be used to:

* Create database structures
* Insert data
* Modify data
* Delete data
* Retrieve data
* Filter and sort data
* Aggregate data
* Combine data from multiple tables

---

# 2. Relational Database Fundamentals

A relational database stores data in **tables**.

Example:

```text
customers

+-------------+------------+-----------+
| customer_id | first_name | balance   |
+-------------+------------+-----------+
| 1           | Aarav      | 12500.50  |
| 2           | Priya      | 8500.00   |
| 3           | Rahul      | 3200.75   |
+-------------+------------+-----------+
```

### Important Terminology

| SQL Term    | Meaning                    |
| ----------- | -------------------------- |
| Table       | Collection of related data |
| Row         | One record                 |
| Column      | Attribute/field            |
| Attribute   | Column                     |
| Tuple       | Row                        |
| Relation    | Table                      |
| Primary Key | Unique identifier          |
| Foreign Key | Reference to another table |

---

# 3. Data Types

Common PostgreSQL data types:

| Data Type      | Purpose                   | Example               |
| -------------- | ------------------------- | --------------------- |
| `INTEGER`      | Whole numbers             | `100`                 |
| `SERIAL`       | Auto-incrementing integer | `1, 2, 3...`          |
| `VARCHAR(n)`   | Variable-length text      | `'Abhimanyu'`         |
| `TEXT`         | Text without fixed length | `'Hello'`             |
| `DATE`         | Date                      | `'2006-05-01'`        |
| `TIMESTAMP`    | Date + time               | `2026-08-28 10:30:00` |
| `DECIMAL(p,s)` | Exact decimal number      | `12500.50`            |
| `BOOLEAN`      | True/False                | `TRUE`                |

---

# 4. Constraints

Constraints are rules applied to table columns.

### Common Constraints

### PRIMARY KEY

Uniquely identifies each row.

```sql
customer_id SERIAL PRIMARY KEY
```

A primary key:

* Must be unique
* Cannot contain `NULL`
* Identifies a record

---

### NOT NULL

Prevents a column from containing `NULL`.

```sql
first_name VARCHAR(100) NOT NULL
```

---

### UNIQUE

Prevents duplicate values.

```sql
email VARCHAR(255) UNIQUE
```

---

### DEFAULT

Provides a value automatically when no value is supplied.

```sql
balance DECIMAL(12,2) DEFAULT 0.00
```

---

### CHECK

Restricts values based on a condition.

```sql
CHECK (balance > 0)
```

---

### FOREIGN KEY

Creates a relationship between tables.

```sql
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
```

---

# 5. DDL — Data Definition Language

DDL is used to define and modify the **structure** of database objects.

Main commands:

```text
CREATE
ALTER
DROP
TRUNCATE
```

---

# 5.1 CREATE

Creates a new database object such as a table.

### Syntax

```sql
CREATE TABLE table_name (
    column1 datatype constraint,
    column2 datatype constraint,
    ...
);
```

### Example

```sql
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    balance DECIMAL(12,2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE
);
```

---

# 5.2 ALTER

Used to modify an existing table's structure.

## Add Column

### Syntax

```sql
ALTER TABLE table_name
ADD COLUMN column_name datatype;
```

### Example

```sql
ALTER TABLE customers
ADD COLUMN phone VARCHAR(10);
```

---

## Drop Column

### Syntax

```sql
ALTER TABLE table_name
DROP COLUMN column_name;
```

### Example

```sql
ALTER TABLE customers
DROP COLUMN phone;
```

---

## Rename Column

### Syntax

```sql
ALTER TABLE table_name
RENAME COLUMN old_name TO new_name;
```

### Example

```sql
ALTER TABLE customers
RENAME COLUMN balance TO account_balance;
```

---

## Change Data Type

### Syntax

```sql
ALTER TABLE table_name
ALTER COLUMN column_name TYPE new_datatype;
```

### Example

```sql
ALTER TABLE customers
ALTER COLUMN account_balance TYPE DECIMAL(15,3);
```

---

## Add Constraint

```sql
ALTER TABLE customers
ADD CONSTRAINT check_balance
CHECK (account_balance > 0);
```

---

## Drop Constraint

```sql
ALTER TABLE customers
DROP CONSTRAINT check_balance;
```

---

# 5.3 DROP

`DROP` removes the database object itself.

### Syntax

```sql
DROP TABLE table_name;
```

### Example

```sql
DROP TABLE customers;
```

After executing this, the table no longer exists.

### Safer version

```sql
DROP TABLE IF EXISTS customers;
```

---

# 5.4 TRUNCATE

`TRUNCATE` removes **all rows** while keeping the table structure.

### Syntax

```sql
TRUNCATE TABLE table_name;
```

### Example

```sql
TRUNCATE TABLE customers;
```

### Reset auto-increment

In PostgreSQL:

```sql
TRUNCATE TABLE customers
RESTART IDENTITY;
```

---

# 6. DDL — DROP vs TRUNCATE

| Feature           | DROP | TRUNCATE |
| ----------------- | ---- | -------- |
| Deletes data      | Yes  | Yes      |
| Deletes structure | Yes  | No       |
| Table remains     | No   | Yes      |
| Removes all rows  | Yes  | Yes      |
| Can use `WHERE`   | No   | No       |

---

# 7. DML — Data Manipulation Language

DML is used to manipulate data **inside existing tables**.

Main commands:

```text
INSERT
UPDATE
DELETE
```

---

# 7.1 INSERT

Used to add records.

### Syntax

```sql
INSERT INTO table_name
    (column1, column2, column3)
VALUES
    (value1, value2, value3);
```

### Example

```sql
INSERT INTO customers
    (first_name, last_name, email, balance)
VALUES
    ('Aarav', 'Sharma', 'aarav@gmail.com', 12500.50);
```

---

## Insert Multiple Rows

```sql
INSERT INTO customers
    (first_name, last_name, email, balance)
VALUES
    ('Aarav', 'Sharma', 'aarav@gmail.com', 12500.50),
    ('Priya', 'Patel', 'priya@gmail.com', 8500.00),
    ('Rahul', 'Verma', 'rahul@gmail.com', 3200.75);
```

### Best Practice

Prefer:

```sql
INSERT INTO customers
    (first_name, last_name, email)
VALUES
    ('Aarav', 'Sharma', 'aarav@gmail.com');
```

over:

```sql
INSERT INTO customers
VALUES (...);
```

Specifying columns makes the query safer and easier to maintain.

---

# 7.2 UPDATE

Used to modify existing records.

### Syntax

```sql
UPDATE table_name
SET column1 = value1,
    column2 = value2
WHERE condition;
```

### Example

```sql
UPDATE customers
SET balance = 15000
WHERE customer_id = 1;
```

### Update Multiple Columns

```sql
UPDATE customers
SET balance = 15000,
    email = 'newemail@gmail.com'
WHERE customer_id = 1;
```

### Update Using Existing Value

Increase every customer's balance by 10%:

```sql
UPDATE customers
SET balance = balance * 1.10;
```

### ⚠️ Important

This:

```sql
UPDATE customers
SET balance = 15000;
```

updates **every row** because there is no `WHERE`.

---

# 7.3 DELETE

Used to remove rows.

### Syntax

```sql
DELETE FROM table_name
WHERE condition;
```

### Example

```sql
DELETE FROM customers
WHERE customer_id = 5;
```

### Delete Multiple Rows

```sql
DELETE FROM customers
WHERE is_active = FALSE;
```

### Delete Everything

```sql
DELETE FROM customers;
```

⚠️ Without `WHERE`, every row is deleted.

---

# 8. DQL — SELECT

`SELECT` retrieves data from a table.

### Select Everything

```sql
SELECT *
FROM customers;
```

### Select Specific Columns

```sql
SELECT first_name, last_name, balance
FROM customers;
```

---

# 9. Column Alias — AS

Aliases give temporary names to columns or expressions.

### Syntax

```sql
SELECT column_name AS alias_name
FROM table_name;
```

### Example

```sql
SELECT
    first_name AS first,
    last_name AS last
FROM customers;
```

---

# 10. String Concatenation

PostgreSQL uses `||` to concatenate strings.

```sql
SELECT
    first_name || ' ' || last_name AS full_name
FROM customers;
```

Example result:

```text
Abhimanyu Saklani
Aarav Sharma
Priya Patel
```

---

# 11. WHERE

`WHERE` filters rows based on a condition.

### Syntax

```sql
SELECT columns
FROM table_name
WHERE condition;
```

### Example

```sql
SELECT *
FROM customers
WHERE balance > 20000;
```

---

# 12. Comparison Operators

| Operator | Meaning               |
| -------- | --------------------- |
| `=`      | Equal                 |
| `<>`     | Not equal             |
| `!=`     | Not equal             |
| `>`      | Greater than          |
| `<`      | Less than             |
| `>=`     | Greater than or equal |
| `<=`     | Less than or equal    |

Example:

```sql
SELECT *
FROM customers
WHERE balance >= 10000;
```

---

# 13. AND / OR / NOT

## AND

All conditions must be true.

```sql
SELECT *
FROM customers
WHERE is_active = TRUE
AND balance > 20000;
```

## OR

At least one condition must be true.

```sql
SELECT *
FROM customers
WHERE balance > 20000
OR is_active = FALSE;
```

## NOT

Negates a condition.

```sql
SELECT *
FROM customers
WHERE NOT is_active = TRUE;
```

---

# 14. BETWEEN

Checks whether a value falls within a range.

### Syntax

```sql
WHERE column_name BETWEEN lower_value AND upper_value;
```

### Example

```sql
SELECT *
FROM customers
WHERE balance BETWEEN 10000 AND 30000;
```

`BETWEEN` is **inclusive**.

Equivalent to:

```sql
WHERE balance >= 10000
AND balance <= 30000;
```

---

# 15. IN

Checks whether a value matches any value in a list.

### Syntax

```sql
WHERE column_name IN (value1, value2, value3);
```

### Example

```sql
SELECT *
FROM customers
WHERE first_name IN ('Aarav', 'Priya', 'Rahul');
```

Instead of:

```sql
WHERE first_name = 'Aarav'
   OR first_name = 'Priya'
   OR first_name = 'Rahul';
```

---

# 16. NULL

`NULL` represents a missing or unknown value.

### Find NULL values

```sql
SELECT *
FROM customers
WHERE date_of_birth IS NULL;
```

### Find non-NULL values

```sql
SELECT *
FROM customers
WHERE date_of_birth IS NOT NULL;
```

### ⚠️ Important

Don't use:

```sql
WHERE date_of_birth = NULL;
```

Use:

```sql
WHERE date_of_birth IS NULL;
```

---

# 17. LIKE

`LIKE` is used for pattern matching.

### Wildcards

| Wildcard | Meaning                 |
| -------- | ----------------------- |
| `%`      | Zero or more characters |
| `_`      | Exactly one character   |

---

## Starts With

```sql
SELECT *
FROM customers
WHERE first_name LIKE 'A%';
```

Matches:

```text
Aarav
Abhishek
Aditya
```

---

## Ends With

```sql
SELECT *
FROM customers
WHERE first_name LIKE '%a';
```

---

## Contains

```sql
SELECT *
FROM customers
WHERE first_name LIKE '%an%';
```

---

## Second Character

```sql
SELECT *
FROM customers
WHERE first_name LIKE '_a%';
```

`_` represents exactly one character.

---

# 18. ORDER BY

Used to sort results.

### Syntax

```sql
SELECT columns
FROM table_name
ORDER BY column_name ASC;
```

### ASC

Ascending order.

```sql
SELECT *
FROM customers
ORDER BY first_name ASC;
```

### DESC

Descending order.

```sql
SELECT *
FROM customers
ORDER BY balance DESC;
```

---

## Multiple Columns

```sql
SELECT *
FROM customers
ORDER BY first_name ASC,
         last_name DESC;
```

The second column is used when the first column contains duplicate values.

---

# 19. DISTINCT

Removes duplicate values from the result.

### Syntax

```sql
SELECT DISTINCT column_name
FROM table_name;
```

### Example

```sql
SELECT DISTINCT first_name
FROM customers;
```

### Multiple Columns

```sql
SELECT DISTINCT first_name, last_name
FROM customers;
```

The **combination** of the selected columns must be unique.

---

# 20. LIMIT

Restricts the number of rows returned.

### Syntax

```sql
SELECT columns
FROM table_name
LIMIT number;
```

### Example

```sql
SELECT *
FROM customers
LIMIT 5;
```

Returns only 5 rows.

---

# 21. Aggregate Functions

Aggregate functions perform calculations across multiple rows.

### Main Aggregate Functions

| Function  | Purpose            |
| --------- | ------------------ |
| `COUNT()` | Counts values/rows |
| `SUM()`   | Calculates total   |
| `AVG()`   | Calculates average |
| `MIN()`   | Finds minimum      |
| `MAX()`   | Finds maximum      |

---

# 21.1 COUNT()

Counts rows or non-NULL values.

```sql
SELECT COUNT(*)
FROM customers;
```

### COUNT(*) vs COUNT(column)

```sql
COUNT(*)
```

Counts **all rows**.

```sql
COUNT(date_of_birth)
```

Counts only rows where `date_of_birth` is **not NULL**.

---

# 21.2 SUM()

Calculates the total of a numeric column.

```sql
SELECT SUM(balance)
FROM customers;
```

---

# 21.3 AVG()

Calculates the average.

```sql
SELECT AVG(balance)
FROM customers;
```

---

# 21.4 MIN()

Returns the smallest value.

```sql
SELECT MIN(balance)
FROM customers;
```

---

# 21.5 MAX()

Returns the largest value.

```sql
SELECT MAX(balance)
FROM customers;
```

---

# 21.6 Multiple Aggregate Functions

```sql
SELECT
    COUNT(*) AS total_customers,
    SUM(balance) AS total_balance,
    AVG(balance) AS average_balance,
    MIN(balance) AS minimum_balance,
    MAX(balance) AS maximum_balance
FROM customers;
```

---

# 22. GROUP BY

`GROUP BY` groups rows having the same value.

It is commonly used with aggregate functions.

### Syntax

```sql
SELECT column_name,
       AGGREGATE_FUNCTION(column_name)
FROM table_name
GROUP BY column_name;
```

### Example

Count customers by active status:

```sql
SELECT
    is_active,
    COUNT(*) AS customer_count
FROM customers
GROUP BY is_active;
```

---

# 23. GROUP BY Multiple Columns

```sql
SELECT
    is_active,
    COUNT(*) AS customer_count,
    AVG(balance) AS average_balance
FROM customers
GROUP BY is_active;
```

---

# 24. HAVING

`HAVING` filters **groups** after `GROUP BY`.

### Syntax

```sql
SELECT column_name,
       AGGREGATE_FUNCTION(column_name)
FROM table_name
GROUP BY column_name
HAVING condition;
```

### Example

Find groups having more than 5 customers:

```sql
SELECT
    is_active,
    COUNT(*) AS customer_count
FROM customers
GROUP BY is_active
HAVING COUNT(*) > 5;
```

---

# 25. WHERE vs HAVING

This is a very important SQL interview concept.

| WHERE                              | HAVING                                |
| ---------------------------------- | ------------------------------------- |
| Filters rows                       | Filters groups                        |
| Applied before grouping            | Applied after grouping                |
| Usually used for normal conditions | Usually used with aggregate functions |

### Example

```sql
SELECT
    is_active,
    AVG(balance) AS average_balance
FROM customers
WHERE balance > 1000
GROUP BY is_active
HAVING AVG(balance) > 10000;
```

Conceptually:

```text
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
 ↓
LIMIT
```

---

# 26. Relationships Between Tables

Relational databases use keys to connect tables.

Example:

```text
customers
----------------
customer_id PK
first_name
last_name


orders
----------------
order_id PK
customer_id FK
product_id FK
quantity
```

Here:

```text
customers.customer_id
          ↓
orders.customer_id
```

---

# 27. Primary Key

A primary key uniquely identifies a row.

Example:

```sql
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100)
);
```

Properties:

* Unique
* Cannot be `NULL`
* One primary key constraint per table
* Can consist of multiple columns (composite primary key)

---

# 28. Foreign Key

A foreign key references a key in another table.

### Syntax

```sql
FOREIGN KEY (column_name)
REFERENCES parent_table(parent_column);
```

### Example

```sql
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);
```

This establishes a relationship between the two tables.

---

# 29. JOINS

A `JOIN` combines data from multiple tables.

Suppose we have:

```text
customers
     |
     | customer_id
     ↓
orders
     |
     | product_id
     ↓
products
```

The `orders` table connects customers and products.

---

# 30. INNER JOIN

Returns only rows where there is a match in **both tables**.

### Syntax

```sql
SELECT columns
FROM table1
INNER JOIN table2
    ON table1.column = table2.column;
```

### Example

```sql
SELECT
    c.first_name,
    o.order_id
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;
```

---

# 31. LEFT JOIN

Returns:

* All rows from the left table
* Matching rows from the right table
* `NULL` when there is no match

### Syntax

```sql
SELECT columns
FROM table1
LEFT JOIN table2
    ON table1.column = table2.column;
```

### Example

Show all customers, including customers with no orders:

```sql
SELECT
    c.customer_id,
    c.first_name,
    o.order_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;
```

---

# 32. RIGHT JOIN

Returns:

* All rows from the right table
* Matching rows from the left table
* `NULL` when there is no match

### Syntax

```sql
SELECT columns
FROM table1
RIGHT JOIN table2
    ON table1.column = table2.column;
```

### Example

```sql
SELECT
    p.product_name,
    o.order_id
FROM orders o
RIGHT JOIN products p
    ON o.product_id = p.product_id;
```

This can show all products, even products that have never been ordered.

---

# 33. FULL OUTER JOIN

Returns:

* Matching rows
* Unmatched rows from the left table
* Unmatched rows from the right table

### Syntax

```sql
SELECT columns
FROM table1
FULL OUTER JOIN table2
    ON table1.column = table2.column;
```

### Example

```sql
SELECT
    c.customer_id,
    c.first_name,
    o.order_id
FROM customers c
FULL OUTER JOIN orders o
    ON c.customer_id = o.customer_id;
```

---

# 34. CROSS JOIN

Produces every possible combination of rows.

If:

```text
Table A = 3 rows
Table B = 4 rows
```

Then:

```text
3 × 4 = 12 rows
```

### Syntax

```sql
SELECT *
FROM table1
CROSS JOIN table2;
```

### Example

```sql
SELECT
    c.first_name,
    p.product_name
FROM customers c
CROSS JOIN products p;
```

---

# 35. SELF JOIN

A self join joins a table with itself.

It is useful for hierarchical relationships such as:

```text
Employee → Manager
Employee → Employee
```

### Syntax

```sql
SELECT ...
FROM table_name a
JOIN table_name b
    ON a.column = b.column;
```

Aliases are required to distinguish the two instances of the same table.

---

# 36. JOIN + Aggregate Functions

Joins become especially powerful when combined with aggregation.

### Total items ordered by each customer

```sql
SELECT
    c.customer_id,
    c.first_name,
    SUM(o.quantity) AS total_items
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name;
```

---

# 37. JOIN + GROUP BY + HAVING

Find customers who ordered more than 5 items:

```sql
SELECT
    c.customer_id,
    c.first_name,
    SUM(o.quantity) AS total_items
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name
HAVING SUM(o.quantity) > 5;
```

This pattern is extremely common in SQL interviews.

---

# 38. SQL Query Execution Order

Although we write:

```sql
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
LIMIT
```

the conceptual execution order is approximately:

```text
1. FROM
2. JOIN
3. WHERE
4. GROUP BY
5. HAVING
6. SELECT
7. DISTINCT
8. ORDER BY
9. LIMIT
```

Understanding this helps explain why, for example, aggregate conditions normally belong in `HAVING` rather than `WHERE`.

---

# 39. Important Differences

## DELETE vs TRUNCATE vs DROP

```text
DELETE
→ Removes rows
→ Can use WHERE
→ Table remains

TRUNCATE
→ Removes all rows
→ Cannot use WHERE
→ Table remains

DROP
→ Removes table + data
→ Table no longer exists
```

---

## WHERE vs HAVING

```text
WHERE
→ Filters individual rows

HAVING
→ Filters groups
```

---

## INNER JOIN vs LEFT JOIN

```text
INNER JOIN
→ Only matching records

LEFT JOIN
→ All left records + matching right records
```

---

# 40. Quick SQL Cheat Sheet

```sql
-- CREATE
CREATE TABLE table_name (
    column datatype constraint
);

-- INSERT
INSERT INTO table_name (column1, column2)
VALUES (value1, value2);

-- SELECT
SELECT column1, column2
FROM table_name;

-- WHERE
SELECT *
FROM table_name
WHERE condition;

-- UPDATE
UPDATE table_name
SET column = value
WHERE condition;

-- DELETE
DELETE FROM table_name
WHERE condition;

-- ORDER BY
SELECT *
FROM table_name
ORDER BY column ASC;

-- DISTINCT
SELECT DISTINCT column
FROM table_name;

-- LIMIT
SELECT *
FROM table_name
LIMIT 10;

-- AGGREGATION
SELECT
    COUNT(*),
    SUM(column),
    AVG(column),
    MIN(column),
    MAX(column)
FROM table_name;

-- GROUP BY
SELECT column, COUNT(*)
FROM table_name
GROUP BY column;

-- HAVING
SELECT column, COUNT(*)
FROM table_name
GROUP BY column
HAVING COUNT(*) > 5;

-- INNER JOIN
SELECT *
FROM table1
INNER JOIN table2
ON table1.id = table2.id;

-- LEFT JOIN
SELECT *
FROM table1
LEFT JOIN table2
ON table1.id = table2.id;
```



```
```
