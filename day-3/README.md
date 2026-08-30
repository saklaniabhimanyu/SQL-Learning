# Day 3 — CTEs & Subqueries

Day 3 covers **Subqueries and Common Table Expressions (CTEs)** used to break down complex SQL problems, perform multi-step analysis, and write more readable queries.

**Database:** PostgreSQL

---

# 📚 Topics Covered

* Subqueries
* Scalar Subqueries
* Single-Row Subqueries
* Multi-Row Subqueries
* Subqueries with `WHERE`
* Subqueries with `SELECT`
* Subqueries with `FROM`
* Subqueries with `HAVING`
* `IN`
* `NOT IN`
* `EXISTS`
* `NOT EXISTS`
* Correlated Subqueries
* Nested Subqueries
* CTEs
* `WITH`
* Multiple CTEs
* CTE + `JOIN`
* CTE + Aggregation
* CTE + Window Functions
* Recursive CTEs
* CTE vs Subquery
* Common SQL Query Patterns

---

# 1. What is a Subquery?

A **subquery** is a query written inside another SQL query.

The inner query is executed as part of the outer query.

### Basic Structure

```sql
SELECT ...
FROM ...
WHERE column = (
    SELECT ...
);
```

The inner query:

```sql
(
    SELECT ...
)
```

is the **subquery**.

---

# 2. Subquery with WHERE

Find employees earning more than the average salary.

```sql
SELECT
    employee_name,
    salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);
```

The subquery calculates the average salary first.

The outer query then finds employees whose salary is greater than that average.

---

# 3. Scalar Subquery

A scalar subquery returns **exactly one value**.

Example:

```sql
SELECT AVG(salary)
FROM employees;
```

The result is a single value.

It can be used with:

```sql
SELECT
    employee_name,
    salary,
    salary - (
        SELECT AVG(salary)
        FROM employees
    ) AS difference
FROM employees;
```

---

# 4. Single-Row Subquery

A single-row subquery returns one row.

Example:

```sql
SELECT *
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
);
```

The subquery returns the highest salary.

The outer query finds the employee(s) having that salary.

---

# 5. Multi-Row Subquery

A multi-row subquery returns multiple values.

For example:

```sql
SELECT department
FROM employees
WHERE salary > 80000;
```

This may return multiple rows.

Use operators such as:

* `IN`
* `ANY`
* `ALL`
* `EXISTS`

---

# 6. IN

`IN` checks whether a value exists in the result returned by a subquery.

### Syntax

```sql
SELECT ...
FROM table
WHERE column IN (
    SELECT column
    FROM table
    WHERE condition
);
```

### Example

Find employees from departments where at least one employee earns more than 90000.

```sql
SELECT *
FROM employees
WHERE department IN (
    SELECT department
    FROM employees
    WHERE salary > 90000
);
```

---

# 7. NOT IN

`NOT IN` returns values that do not appear in the subquery result.

```sql
SELECT *
FROM employees
WHERE department NOT IN (
    SELECT department
    FROM employees
    WHERE salary > 90000
);
```

### Important

Be careful with `NULL` values when using `NOT IN`.

If the subquery can return `NULL`, the result may not behave as expected.

---

# 8. EXISTS

`EXISTS` checks whether the subquery returns **at least one row**.

### Syntax

```sql
SELECT ...
FROM table1
WHERE EXISTS (
    SELECT 1
    FROM table2
    WHERE condition
);
```

### Example

Find customers who have placed at least one order.

```sql
SELECT
    c.customer_id,
    c.first_name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

The actual value returned by `SELECT 1` is not important.

The database only checks whether a matching row exists.

---

# 9. NOT EXISTS

`NOT EXISTS` checks whether the subquery returns **no rows**.

Example:

Find customers who have never placed an order.

```sql
SELECT
    c.customer_id,
    c.first_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

---

# 10. EXISTS vs IN

Both can be used to check whether related records exist.

### IN

```sql
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
);
```

### EXISTS

```sql
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

### General idea

```text
IN
→ Compare against a set of returned values

EXISTS
→ Check whether at least one matching row exists
```

---

# 11. Correlated Subquery

A correlated subquery references a column from the **outer query**.

The inner query depends on the current outer row.

### Example

Find employees earning more than their department average.

```sql
SELECT
    e.employee_name,
    e.department,
    e.salary
FROM employees e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department = e.department
);
```

The inner query references:

```sql
e.department
```

from the outer query.

---

# 12. Non-Correlated vs Correlated Subquery

### Non-Correlated

The inner query is independent of the outer query.

```sql
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);
```

### Correlated

The inner query depends on the outer query.

```sql
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department = e.department
);
```

---

# 13. Subquery in SELECT

A subquery can be placed inside the `SELECT` list.

```sql
SELECT
    employee_name,
    salary,
    (
        SELECT AVG(salary)
        FROM employees
    ) AS average_salary
FROM employees;
```

Each row displays the overall average salary.

---

# 14. Subquery in FROM

A subquery inside `FROM` acts like a temporary derived table.

### Syntax

```sql
SELECT ...
FROM (
    SELECT ...
    FROM table
) alias;
```

### Example

```sql
SELECT *
FROM (
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department
) department_salary;
```

The subquery creates a temporary result that the outer query can use.

---

# 15. Subquery in HAVING

Subqueries can also be used with `HAVING`.

Example:

```sql
SELECT
    department,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM employees
);
```

This finds departments whose average salary is greater than the overall average.

---

# 16. Nested Subqueries

A subquery can contain another subquery.

Example:

```sql
SELECT *
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE salary < (
        SELECT MAX(salary)
        FROM employees
    )
);
```

This can be used to find the second-highest salary.

---

# 17. ANY

`ANY` compares a value against values returned by a subquery.

### Syntax

```sql
WHERE column operator ANY (
    SELECT column
    FROM table
);
```

Example:

```sql
SELECT *
FROM employees
WHERE salary > ANY (
    SELECT salary
    FROM employees
    WHERE department = 'HR'
);
```

The condition is true if the comparison succeeds for **at least one** value.

---

# 18. ALL

`ALL` compares a value against every value returned by a subquery.

### Syntax

```sql
WHERE column operator ALL (
    SELECT column
    FROM table
);
```

Example:

```sql
SELECT *
FROM employees
WHERE salary > ALL (
    SELECT salary
    FROM employees
    WHERE department = 'HR'
);
```

The employee must earn more than **every** salary returned by the subquery.

---

# 19. CTE — Common Table Expression

A **CTE** is a temporary named result set that can be referenced within a single SQL statement.

CTEs are created using `WITH`.

### Basic Syntax

```sql
WITH cte_name AS (
    SELECT ...
)
SELECT ...
FROM cte_name;
```

---

# 20. Simple CTE

Find employees earning more than 80000.

```sql
WITH high_salary AS (
    SELECT *
    FROM employees
    WHERE salary > 80000
)
SELECT *
FROM high_salary;
```

The CTE:

```text
high_salary
```

acts like a temporary result for that query.

---

# 21. CTE with Aggregation

Calculate average salary by department.

```sql
WITH department_salary AS (
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department
)
SELECT *
FROM department_salary;
```

---

# 22. CTE with WHERE

```sql
WITH department_salary AS (
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department
)
SELECT *
FROM department_salary
WHERE average_salary > 75000;
```

---

# 23. Multiple CTEs

Multiple CTEs can be defined in the same `WITH` clause.

### Syntax

```sql
WITH cte1 AS (
    SELECT ...
),
cte2 AS (
    SELECT ...
)
SELECT ...
FROM cte1
JOIN cte2
ON ...;
```

### Example

```sql
WITH department_avg AS (
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department
),
department_count AS (
    SELECT
        department,
        COUNT(*) AS employee_count
    FROM employees
    GROUP BY department
)
SELECT
    a.department,
    a.average_salary,
    c.employee_count
FROM department_avg a
JOIN department_count c
    ON a.department = c.department;
```

---

# 24. CTE + JOIN

```sql
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.first_name,
    co.order_count
FROM customers c
JOIN customer_orders co
    ON c.customer_id = co.customer_id;
```

---

# 25. CTE + Aggregation

Find customers whose total spending is greater than 20000.

```sql
WITH customer_spending AS (
    SELECT
        o.customer_id,
        SUM(o.quantity * p.price) AS total_spending
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
    GROUP BY o.customer_id
)
SELECT *
FROM customer_spending
WHERE total_spending > 20000;
```

---

# 26. CTE + Window Function

CTEs can make window-function queries easier to read.

Example:

```sql
WITH ranked_employees AS (
    SELECT
        employee_name,
        department,
        salary,
        ROW_NUMBER() OVER (
            PARTITION BY department
            ORDER BY salary DESC
        ) AS rn
    FROM employees
)
SELECT *
FROM ranked_employees
WHERE rn <= 2;
```

This finds the top 2 employees in each department.

---

# 27. Recursive CTE

A recursive CTE references itself.

It is useful for hierarchical or sequential data.

### Basic Syntax

```sql
WITH RECURSIVE cte_name AS (
    -- Anchor query
    SELECT ...

    UNION ALL

    -- Recursive query
    SELECT ...
    FROM cte_name
    WHERE condition
)
SELECT *
FROM cte_name;
```

---

# 28. Recursive CTE Example

Generate numbers from 1 to 10.

```sql
WITH RECURSIVE numbers AS (
    SELECT 1 AS number

    UNION ALL

    SELECT number + 1
    FROM numbers
    WHERE number < 10
)
SELECT *
FROM numbers;
```

Result:

```text
1
2
3
4
5
6
7
8
9
10
```

---

# 29. Recursive CTE Structure

A recursive CTE contains two main parts:

```text
Anchor Query
     ↓
UNION ALL
     ↓
Recursive Query
     ↓
Repeat until condition becomes false
```

Common use cases:

* Employee-manager hierarchies
* Organization structures
* Category trees
* Graph traversal
* Generating sequences

---

# 30. CTE vs Subquery

| CTE                                               | Subquery                                     |
| ------------------------------------------------- | -------------------------------------------- |
| Defined using `WITH`                              | Written directly inside query                |
| Easier to read for complex queries                | Good for simple queries                      |
| Can define multiple CTEs                          | Can nest multiple subqueries                 |
| Can be referenced multiple times in the statement | Usually repeated if needed                   |
| Supports recursive queries                        | Does not provide recursive CTE functionality |
| Good for breaking queries into steps              | Good for small embedded calculations         |

---

# 31. CTE vs Temporary Table

| CTE                                 | Temporary Table                                          |
| ----------------------------------- | -------------------------------------------------------- |
| Exists for one SQL statement        | Exists for a session/transaction depending on definition |
| No explicit table creation required | Explicitly created                                       |
| Good for query organization         | Good for storing intermediate results                    |
| Usually used within one query       | Can be reused across multiple queries                    |

---

# 32. Common Interview Query — Second Highest Salary

### Using Subquery

```sql
SELECT MAX(salary) AS second_highest
FROM employees
WHERE salary < (
    SELECT MAX(salary)
    FROM employees
);
```

### Using DENSE_RANK()

```sql
SELECT *
FROM (
    SELECT
        employee_name,
        salary,
        DENSE_RANK() OVER (
            ORDER BY salary DESC
        ) AS salary_rank
    FROM employees
) ranked
WHERE salary_rank = 2;
```

---

# 33. Common Interview Query — Employees Above Department Average

### Correlated Subquery

```sql
SELECT
    e.employee_name,
    e.department,
    e.salary
FROM employees e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department = e.department
);
```

### CTE + JOIN

```sql
WITH department_avg AS (
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department
)
SELECT
    e.employee_name,
    e.department,
    e.salary,
    d.average_salary
FROM employees e
JOIN department_avg d
    ON e.department = d.department
WHERE e.salary > d.average_salary;
```

---

# 34. Common Interview Query — Customers With Orders

### EXISTS

```sql
SELECT
    c.customer_id,
    c.first_name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

### JOIN

```sql
SELECT DISTINCT
    c.customer_id,
    c.first_name
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id;
```

Both can solve similar problems, but they express different logic.

---

# 35. Common Interview Query — Customers Without Orders

### NOT EXISTS

```sql
SELECT
    c.customer_id,
    c.first_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

### LEFT JOIN

```sql
SELECT
    c.customer_id,
    c.first_name
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;
```

---

# 36. Query Execution Concept

For a query containing a subquery:

```text
Outer Query
    ↓
Subquery
    ↓
Subquery Result
    ↓
Outer Query Uses Result
```

For a CTE:

```text
WITH
 ↓
CTE Result
 ↓
Main Query
```

---

# 37. Important SQL Patterns

### Subquery

```sql
SELECT ...
FROM ...
WHERE column > (
    SELECT ...
);
```

### IN

```sql
SELECT ...
FROM ...
WHERE column IN (
    SELECT ...
);
```

### EXISTS

```sql
SELECT ...
FROM table1 t1
WHERE EXISTS (
    SELECT 1
    FROM table2 t2
    WHERE t2.id = t1.id
);
```

### CTE

```sql
WITH cte_name AS (
    SELECT ...
)
SELECT ...
FROM cte_name;
```

### Multiple CTEs

```sql
WITH cte1 AS (
    SELECT ...
),
cte2 AS (
    SELECT ...
)
SELECT ...
FROM cte1
JOIN cte2
ON ...;
```

### Recursive CTE

```sql
WITH RECURSIVE cte_name AS (
    SELECT ...

    UNION ALL

    SELECT ...
    FROM cte_name
    WHERE condition
)
SELECT *
FROM cte_name;
```

---

# 38. Quick Revision

```text
SUBQUERY
→ Query inside another query

SCALAR SUBQUERY
→ Returns one value

SINGLE-ROW SUBQUERY
→ Returns one row

MULTI-ROW SUBQUERY
→ Returns multiple rows

IN
→ Match against returned values

NOT IN
→ Exclude returned values

EXISTS
→ At least one matching row exists

NOT EXISTS
→ No matching row exists

CORRELATED SUBQUERY
→ Inner query depends on outer query

ANY
→ Condition true for at least one value

ALL
→ Condition true for every value
```

```text
CTE
→ Temporary named result for one SQL statement

WITH
→ Defines a CTE

MULTIPLE CTE
→ Multiple named query results

RECURSIVE CTE
→ CTE that references itself
```

---

# 39. Key Interview Differences

### IN vs EXISTS

```text
IN
→ Compares a value against a set

EXISTS
→ Checks whether matching rows exist
```

### EXISTS vs NOT EXISTS

```text
EXISTS
→ Matching record exists

NOT EXISTS
→ Matching record does not exist
```

### CTE vs Subquery

```text
CTE
→ Better readability for multi-step queries

Subquery
→ Convenient for smaller embedded queries
```

### CTE vs Temporary Table

```text
CTE
→ One SQL statement

TEMP TABLE
→ Can persist for multiple statements
```

---


