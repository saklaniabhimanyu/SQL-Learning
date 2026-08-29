# Day 2 — Window Functions, Views & Indexes

Day 2 covers advanced SQL concepts used for **analytical queries, reusable database logic, and query performance optimization**.

**Database:** PostgreSQL

---

# 📚 Topics Covered

* Window Functions
* `OVER()`
* `PARTITION BY`
* `ORDER BY` with Window Functions
* `ROW_NUMBER()`
* `RANK()`
* `DENSE_RANK()`
* `NTILE()`
* `LAG()`
* `LEAD()`
* `FIRST_VALUE()`
* `LAST_VALUE()`
* Aggregate Window Functions
* Window Frame
* Views
* Creating Views
* Updating Views
* Dropping Views
* View vs Table
* View vs CTE
* Indexes
* Creating Indexes
* Composite Indexes
* Unique Indexes
* Partial Indexes
* Index Benefits
* Index Drawbacks
* When to Use Indexes
* `EXPLAIN`
* `EXPLAIN ANALYZE`

---

# 1. Window Functions

A **Window Function** performs a calculation across a set of related rows without combining those rows into a single row.

Unlike `GROUP BY`, window functions **do not reduce the number of rows**.

### Example

Suppose:

```text
employees

id | name    | department | salary
---|---------|------------|-------
1  | Aarav   | IT         | 70000
2  | Priya   | IT         | 80000
3  | Rahul   | HR         | 60000
4  | Sneha   | HR         | 75000
```

Using `GROUP BY`:

```sql
SELECT department, AVG(salary)
FROM employees
GROUP BY department;
```

Result:

```text
IT | 75000
HR | 67500
```

Rows are collapsed into groups.

With a window function:

```sql
SELECT
    name,
    department,
    salary,
    AVG(salary) OVER (
        PARTITION BY department
    ) AS department_avg
FROM employees;
```

Result:

```text
name  | department | salary | department_avg
------+------------+--------+---------------
Aarav | IT         | 70000  | 75000
Priya | IT         | 80000  | 75000
Rahul | HR         | 60000  | 67500
Sneha | HR         | 75000  | 67500
```

Every original row is preserved.

---

# 2. OVER()

`OVER()` defines the window over which a function operates.

### Syntax

```sql
function_name() OVER (
    [PARTITION BY column]
    [ORDER BY column]
);
```

Example:

```sql
SELECT
    name,
    salary,
    AVG(salary) OVER () AS average_salary
FROM employees;
```

The average is calculated across the entire result set.

---

# 3. PARTITION BY

`PARTITION BY` divides rows into groups for the window function.

Unlike `GROUP BY`, it does **not collapse rows**.

### Syntax

```sql
function_name() OVER (
    PARTITION BY column_name
);
```

### Example

```sql
SELECT
    name,
    department,
    salary,
    AVG(salary) OVER (
        PARTITION BY department
    ) AS department_avg
FROM employees;
```

Each department gets its own calculation.

---

# 4. ORDER BY in Window Functions

`ORDER BY` determines the order in which rows are processed.

### Example

```sql
SELECT
    name,
    salary,
    ROW_NUMBER() OVER (
        ORDER BY salary DESC
    ) AS row_num
FROM employees;
```

Highest salary gets `1`.

---

# 5. ROW_NUMBER()

Assigns a unique sequential number to each row.

### Syntax

```sql
ROW_NUMBER() OVER (
    ORDER BY column_name
);
```

### Example

```sql
SELECT
    name,
    salary,
    ROW_NUMBER() OVER (
        ORDER BY salary DESC
    ) AS row_number
FROM employees;
```

Result:

```text
name  | salary | row_number
------+--------+-----------
Priya | 80000  | 1
Sneha | 75000  | 2
Aarav | 70000  | 3
Rahul | 60000  | 4
```

Even if two employees have the same salary, `ROW_NUMBER()` gives them different numbers.

---

# 6. ROW_NUMBER() with PARTITION BY

Generate rankings separately for each department.

```sql
SELECT
    name,
    department,
    salary,
    ROW_NUMBER() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS row_number
FROM employees;
```

Example:

```text
department | name  | salary | row_number
-----------|-------|--------|-----------
IT         | Priya | 80000  | 1
IT         | Aarav | 70000  | 2
HR         | Sneha | 75000  | 1
HR         | Rahul | 60000  | 2
```

---

# 7. RANK()

Assigns ranks to rows.

If two rows have the same value, they receive the same rank.

The next rank is skipped.

Example salaries:

```text
100000
100000
80000
70000
```

Using `RANK()`:

```text
1
1
3
4
```

### Syntax

```sql
RANK() OVER (
    ORDER BY column_name DESC
);
```

---

# 8. DENSE_RANK()

Similar to `RANK()`, but does **not skip ranks**.

Example:

```text
Salary:
100000
100000
80000
70000
```

Result:

```text
RANK():

1
1
3
4


DENSE_RANK():

1
1
2
3
```

### Syntax

```sql
DENSE_RANK() OVER (
    ORDER BY column_name DESC
);
```

---

# 9. ROW_NUMBER vs RANK vs DENSE_RANK

| Function       | Duplicate Values  | Gaps |
| -------------- | ----------------- | ---- |
| `ROW_NUMBER()` | Different numbers | No   |
| `RANK()`       | Same rank         | Yes  |
| `DENSE_RANK()` | Same rank         | No   |

### Example

```text
Values:

100
100
90
80
```

```text
ROW_NUMBER
1
2
3
4

RANK
1
1
3
4

DENSE_RANK
1
1
2
3
```

---

# 10. NTILE()

Divides rows into approximately equal groups.

### Syntax

```sql
NTILE(number_of_groups) OVER (
    ORDER BY column_name
);
```

### Example

Divide employees into 4 salary groups:

```sql
SELECT
    name,
    salary,
    NTILE(4) OVER (
        ORDER BY salary DESC
    ) AS salary_quartile
FROM employees;
```

Useful for:

* Quartiles
* Customer segmentation
* Performance groups
* Percentile-style analysis

---

# 11. LAG()

`LAG()` accesses a value from a **previous row**.

### Syntax

```sql
LAG(column_name) OVER (
    ORDER BY column_name
);
```

### Example

```sql
SELECT
    order_date,
    sales,
    LAG(sales) OVER (
        ORDER BY order_date
    ) AS previous_day_sales
FROM daily_sales;
```

This is useful for comparing:

```text
Current value
      ↓
Previous value
```

---

# 12. LEAD()

`LEAD()` accesses a value from a **following row**.

### Syntax

```sql
LEAD(column_name) OVER (
    ORDER BY column_name
);
```

### Example

```sql
SELECT
    order_date,
    sales,
    LEAD(sales) OVER (
        ORDER BY order_date
    ) AS next_day_sales
FROM daily_sales;
```

---

# 13. LAG vs LEAD

```text
LAG
← Previous row


Current row


LEAD
→ Next row
```

| Function | Accesses     |
| -------- | ------------ |
| `LAG()`  | Previous row |
| `LEAD()` | Next row     |

Common use cases:

* Month-over-month comparison
* Day-over-day comparison
* Growth calculations
* Previous transaction
* Next transaction

---

# 14. FIRST_VALUE()

Returns the first value in the window.

### Syntax

```sql
FIRST_VALUE(column_name) OVER (
    ORDER BY column_name
);
```

### Example

```sql
SELECT
    name,
    salary,
    FIRST_VALUE(name) OVER (
        ORDER BY salary DESC
    ) AS highest_paid_employee
FROM employees;
```

---

# 15. LAST_VALUE()

Returns the last value according to the window ordering.

```sql
SELECT
    name,
    salary,
    LAST_VALUE(name) OVER (
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS lowest_paid_employee
FROM employees;
```

### Important

`LAST_VALUE()` can behave unexpectedly if the window frame is not explicitly defined.

---

# 16. Aggregate Window Functions

Aggregate functions can also be used as window functions.

Examples:

```sql
SUM() OVER()
AVG() OVER()
COUNT() OVER()
MIN() OVER()
MAX() OVER()
```

### Example

```sql
SELECT
    name,
    salary,
    SUM(salary) OVER () AS total_salary,
    AVG(salary) OVER () AS average_salary
FROM employees;
```

Unlike normal aggregation, every employee row is preserved.

---

# 17. Running Total

A running total can be calculated using `SUM()` with `ORDER BY`.

```sql
SELECT
    order_date,
    sales,
    SUM(sales) OVER (
        ORDER BY order_date
    ) AS running_total
FROM daily_sales;
```

Example:

```text
Date | Sales | Running Total
-----|-------|--------------
1    | 100   | 100
2    | 200   | 300
3    | 150   | 450
4    | 250   | 700
```

---

# 18. Running Total by Group

```sql
SELECT
    customer_id,
    order_date,
    amount,
    SUM(amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS running_total
FROM orders;
```

Each customer gets an independent running total.

---

# 19. Window Frame

A window frame defines which rows around the current row are included.

Example:

```sql
ROWS BETWEEN UNBOUNDED PRECEDING
AND CURRENT ROW
```

means:

```text
Start from first row
        ↓
Include rows up to current row
```

Common frame definitions:

```text
UNBOUNDED PRECEDING
CURRENT ROW
UNBOUNDED FOLLOWING
n PRECEDING
n FOLLOWING
```

---

# 20. Window Function Interview Pattern

A very common pattern is finding the top employee in each department.

```sql
SELECT *
FROM (
    SELECT
        name,
        department,
        salary,
        ROW_NUMBER() OVER (
            PARTITION BY department
            ORDER BY salary DESC
        ) AS rn
    FROM employees
) ranked
WHERE rn = 1;
```

This pattern is useful for:

* Top N employees
* Top N products
* Highest transaction per customer
* Latest record per user
* First/last event per group

---

# 21. Views

A **View** is a virtual table based on the result of a SQL query.

It does not normally store the query result as a separate physical table.

### Why use Views?

* Simplify complex queries
* Reuse SQL logic
* Hide unnecessary columns
* Improve data access control
* Provide a clean interface to data

---

# 22. CREATE VIEW

### Syntax

```sql
CREATE VIEW view_name AS
SELECT ...
FROM ...
WHERE ...;
```

### Example

```sql
CREATE VIEW active_customers AS
SELECT
    customer_id,
    first_name,
    last_name,
    email
FROM customers
WHERE is_active = TRUE;
```

Use the view:

```sql
SELECT *
FROM active_customers;
```

---

# 23. CREATE OR REPLACE VIEW

Used to modify an existing view.

### Syntax

```sql
CREATE OR REPLACE VIEW view_name AS
SELECT ...;
```

### Example

```sql
CREATE OR REPLACE VIEW active_customers AS
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    balance
FROM customers
WHERE is_active = TRUE;
```

---

# 24. DROP VIEW

Removes a view.

### Syntax

```sql
DROP VIEW view_name;
```

### Example

```sql
DROP VIEW active_customers;
```

Safer:

```sql
DROP VIEW IF EXISTS active_customers;
```

---

# 25. View with JOIN

Views can contain complex queries.

```sql
CREATE VIEW customer_orders AS
SELECT
    c.customer_id,
    c.first_name,
    o.order_id,
    o.order_date,
    o.quantity
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;
```

Now:

```sql
SELECT *
FROM customer_orders;
```

can be used instead of repeatedly writing the entire join.

---

# 26. View with Aggregation

```sql
CREATE VIEW customer_spending AS
SELECT
    c.customer_id,
    c.first_name,
    SUM(o.quantity * p.price) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN products p
    ON o.product_id = p.product_id
GROUP BY
    c.customer_id,
    c.first_name;
```

Then:

```sql
SELECT *
FROM customer_spending;
```

---

# 27. View vs Table

| View                                | Table               |
| ----------------------------------- | ------------------- |
| Virtual table                       | Physical table      |
| Based on a query                    | Stores data         |
| Usually doesn't store separate data | Stores rows         |
| Useful for reusable queries         | Used to store data  |
| Depends on underlying tables        | Independent storage |

---

# 28. View vs CTE

| View                          | CTE                               |
| ----------------------------- | --------------------------------- |
| Stored in database            | Exists only for one query         |
| Reusable                      | Not reusable across queries       |
| Can simplify repeated queries | Good for complex one-time queries |
| Created using `CREATE VIEW`   | Created using `WITH`              |

Example CTE:

```sql
WITH active_customers AS (
    SELECT *
    FROM customers
    WHERE is_active = TRUE
)
SELECT *
FROM active_customers;
```

---

# 29. Indexes

An **Index** is a database structure used to speed up data retrieval.

Think of an index like the index of a book.

Without an index:

```text
Database
   ↓
Check many rows
   ↓
Find matching row
```

With an index:

```text
Query
  ↓
Index
  ↓
Find relevant rows faster
```

---

# 30. CREATE INDEX

### Syntax

```sql
CREATE INDEX index_name
ON table_name(column_name);
```

### Example

```sql
CREATE INDEX idx_customers_email
ON customers(email);
```

This can improve queries such as:

```sql
SELECT *
FROM customers
WHERE email = 'user@gmail.com';
```

---

# 31. Composite Index

An index can contain multiple columns.

### Syntax

```sql
CREATE INDEX index_name
ON table_name(column1, column2);
```

### Example

```sql
CREATE INDEX idx_customer_name
ON customers(first_name, last_name);
```

Useful when queries frequently filter or sort using those columns.

---

# 32. Unique Index

A unique index prevents duplicate values.

### Syntax

```sql
CREATE UNIQUE INDEX index_name
ON table_name(column_name);
```

### Example

```sql
CREATE UNIQUE INDEX idx_unique_email
ON customers(email);
```

A `UNIQUE` constraint is commonly backed by a unique index in PostgreSQL.

---

# 33. Partial Index

A partial index indexes only rows satisfying a condition.

### Syntax

```sql
CREATE INDEX index_name
ON table_name(column_name)
WHERE condition;
```

### Example

```sql
CREATE INDEX idx_active_customers
ON customers(customer_id)
WHERE is_active = TRUE;
```

This can be useful when only a subset of rows is frequently queried.

---

# 34. DROP INDEX

### Syntax

```sql
DROP INDEX index_name;
```

### Example

```sql
DROP INDEX idx_customers_email;
```

Safer:

```sql
DROP INDEX IF EXISTS idx_customers_email;
```

---

# 35. Advantages of Indexes

Indexes can:

* Speed up `SELECT`
* Improve filtering
* Improve joins
* Improve sorting
* Improve searches on indexed columns

---

# 36. Disadvantages of Indexes

Indexes are not free.

They:

* Consume storage
* Make `INSERT` slower
* Make `UPDATE` slower
* Make `DELETE` slower
* Require maintenance

Therefore:

> Do not create an index on every column.

---

# 37. When Should You Create an Index?

Good candidates often include columns frequently used in:

```text
WHERE
JOIN
ORDER BY
GROUP BY
```

Examples:

```sql
WHERE email = ...
```

```sql
JOIN orders
ON customers.customer_id = orders.customer_id
```

```sql
ORDER BY created_at
```

---

# 38. When an Index May Not Help

Indexes may be less useful when:

* The table is very small
* The column has very low selectivity
* The column is rarely queried
* The table receives very frequent writes
* The query returns a very large percentage of the table

---

# 39. EXPLAIN

`EXPLAIN` shows the query execution plan chosen by PostgreSQL.

### Syntax

```sql
EXPLAIN
SELECT ...
FROM ...
WHERE ...;
```

Example:

```sql
EXPLAIN
SELECT *
FROM customers
WHERE email = 'user@gmail.com';
```

It helps understand:

* How PostgreSQL executes the query
* Whether an index may be used
* Estimated cost
* Scan methods

---

# 40. EXPLAIN ANALYZE

`EXPLAIN ANALYZE` actually executes the query and provides runtime information.

### Syntax

```sql
EXPLAIN ANALYZE
SELECT ...
FROM ...
WHERE ...;
```

Example:

```sql
EXPLAIN ANALYZE
SELECT *
FROM customers
WHERE email = 'user@gmail.com';
```

Useful for query performance analysis.

---

# 41. Sequential Scan vs Index Scan

### Sequential Scan

PostgreSQL checks rows sequentially.

```text
Table
 ↓
Row 1
 ↓
Row 2
 ↓
Row 3
 ↓
...
```

### Index Scan

PostgreSQL can use an index to locate matching rows.

```text
Query
 ↓
Index
 ↓
Relevant row(s)
```

An index scan is not automatically better in every situation. PostgreSQL chooses the execution plan based on estimated cost.

---

# 42. Window Functions vs GROUP BY

Very important interview concept.

### GROUP BY

Reduces multiple rows into groups.

```sql
SELECT
    department,
    AVG(salary)
FROM employees
GROUP BY department;
```

Result:

```text
department | average
-----------|--------
IT         | 75000
HR         | 67500
```

### Window Function

Keeps the original rows.

```sql
SELECT
    name,
    department,
    salary,
    AVG(salary) OVER (
        PARTITION BY department
    ) AS department_avg
FROM employees;
```

Result:

```text
name  | department | salary | department_avg
------+------------+--------+---------------
Aarav | IT         | 70000  | 75000
Priya | IT         | 80000  | 75000
Rahul | HR         | 60000  | 67500
Sneha | HR         | 75000  | 67500
```

### Key Difference

```text
GROUP BY
→ Combines rows

WINDOW FUNCTION
→ Keeps rows + calculates across them
```

---

# 43. Important Window Function Syntax

```sql
FUNCTION() OVER (
    PARTITION BY column
    ORDER BY column
);
```

Think:

```text
OVER()
 ├── PARTITION BY → Divide into groups
 └── ORDER BY     → Decide row order
```

---

# 44. Day 2 Interview Patterns

## Find Top 3 Salaries in Each Department

```sql
SELECT *
FROM (
    SELECT
        name,
        department,
        salary,
        DENSE_RANK() OVER (
            PARTITION BY department
            ORDER BY salary DESC
        ) AS salary_rank
    FROM employees
) ranked
WHERE salary_rank <= 3;
```

---

## Find Previous Transaction

```sql
SELECT
    customer_id,
    order_date,
    amount,
    LAG(amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS previous_amount
FROM orders;
```

---

## Find Next Transaction

```sql
SELECT
    customer_id,
    order_date,
    amount,
    LEAD(amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS next_amount
FROM orders;
```

---

## Calculate Difference from Previous Row

```sql
SELECT
    order_date,
    sales,
    sales - LAG(sales) OVER (
        ORDER BY order_date
    ) AS sales_difference
FROM daily_sales;
```

---

# 45. Quick Revision

```text
WINDOW FUNCTIONS
----------------

OVER()
→ Defines the window

PARTITION BY
→ Divides rows into groups

ORDER BY
→ Defines order inside the window

ROW_NUMBER()
→ Unique sequential number

RANK()
→ Same rank for ties + gaps

DENSE_RANK()
→ Same rank for ties + no gaps

NTILE()
→ Divides rows into groups

LAG()
→ Previous row

LEAD()
→ Next row

FIRST_VALUE()
→ First value

LAST_VALUE()
→ Last value

SUM() OVER()
→ Windowed total

AVG() OVER()
→ Windowed average
```

---

```text
VIEWS
-----

CREATE VIEW
→ Create reusable virtual table

CREATE OR REPLACE VIEW
→ Modify view definition

DROP VIEW
→ Delete view

VIEW
→ Stored query / virtual table
```

---

```text
INDEXES
-------

CREATE INDEX
→ Create index

CREATE UNIQUE INDEX
→ Unique index

DROP INDEX
→ Remove index

EXPLAIN
→ Show query plan

EXPLAIN ANALYZE
→ Execute + show actual performance
```

---

# 46. Key  Differences

### ROW_NUMBER vs RANK vs DENSE_RANK

```text
ROW_NUMBER
1 2 3 4

RANK
1 1 3 4

DENSE_RANK
1 1 2 3
```

### LAG vs LEAD

```text
LAG  → Previous row
LEAD → Next row
```

### GROUP BY vs Window Function

```text
GROUP BY
→ Reduces rows

WINDOW FUNCTION
→ Preserves rows
```

### View vs CTE

```text
VIEW
→ Stored and reusable

CTE
→ Temporary for one query
```

### Index

```text
Faster reads
       +
More storage
       +
Slower writes
```

---
