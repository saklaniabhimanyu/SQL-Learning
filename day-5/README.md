# Day 5 — Advanced SQL, Functions & Procedures

Day 5 covers advanced PostgreSQL features used for **data transformation, conditional logic, set operations, conflict handling, reusable database logic, and stored routines**.

**Database:** PostgreSQL

---

# Topics Covered

* `CASE`
* `COALESCE`
* `NULLIF`
* Type Casting
* String Functions
* Date & Time Functions
* Mathematical Functions
* Conditional Aggregation
* `FILTER`
* `UNION`
* `UNION ALL`
* `INTERSECT`
* `EXCEPT`
* `DISTINCT ON`
* `ON CONFLICT`
* `INSERT ... RETURNING`
* `UPDATE ... RETURNING`
* `DELETE ... RETURNING`
* UPSERT
* User-Defined Functions
* `CREATE FUNCTION`
* Function Parameters
* `RETURNS`
* `RETURN`
* `LANGUAGE`
* Stored Procedures
* `CREATE PROCEDURE`
* `CALL`
* Functions vs Procedures

---

# 1. CASE

`CASE` is used to implement conditional logic in SQL.

### Syntax

```sql
CASE
    WHEN condition THEN result
    WHEN condition THEN result
    ELSE result
END
```

Example:

```sql
SELECT
    employee_name,
    salary,
    CASE
        WHEN salary >= 90000 THEN 'High'
        WHEN salary >= 70000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_category
FROM employees;
```

---

# 2. CASE with Multiple Conditions

```sql
SELECT
    employee_name,
    salary,
    CASE
        WHEN salary >= 90000 THEN 'A'
        WHEN salary >= 80000 THEN 'B'
        WHEN salary >= 70000 THEN 'C'
        ELSE 'D'
    END AS grade
FROM employees;
```

---

# 3. CASE with Aggregation

```sql
SELECT
    department,
    COUNT(
        CASE
            WHEN salary >= 80000 THEN 1
        END
    ) AS high_salary_count
FROM employees
GROUP BY department;
```

---

# 4. Conditional Aggregation

Conditional aggregation combines aggregate functions with conditions.

```sql
SELECT
    department,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN salary >= 80000 THEN 1 END) AS high_salary,
    COUNT(CASE WHEN salary < 80000 THEN 1 END) AS low_salary
FROM employees
GROUP BY department;
```

---

# 5. FILTER

PostgreSQL supports `FILTER` for conditional aggregation.

### Syntax

```sql
aggregate_function(...) FILTER (
    WHERE condition
)
```

Example:

```sql
SELECT
    department,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER(WHERE salary >= 80000) AS high_salary,
    COUNT(*) FILTER(WHERE salary < 80000) AS low_salary
FROM employees
GROUP BY department;
```

---

# 6. COALESCE

`COALESCE` returns the first non-NULL value.

### Syntax

```sql
COALESCE(value1,value2,...)
```

Example:

```sql
SELECT
    employee_name,
    COALESCE(department,'Unknown') AS department
FROM employees;
```

Another example:

```sql
SELECT
    customer_id,
    COALESCE(balance,0) AS balance
FROM customers;
```

---

# 7. NULLIF

`NULLIF` returns `NULL` when two values are equal.

### Syntax

```sql
NULLIF(value1,value2)
```

Example:

```sql
SELECT NULLIF(10,10);
```

Example with division:

```sql
SELECT
    total_sales / NULLIF(total_orders,0)
FROM sales;
```

---

# 8. CAST

`CAST` converts a value from one data type to another.

### Syntax

```sql
CAST(value AS datatype)
```

Example:

```sql
SELECT CAST(salary AS INTEGER)
FROM employees;
```

PostgreSQL shorthand:

```sql
SELECT salary::INTEGER
FROM employees;
```

---

# 9. String Functions

### `UPPER`

```sql
SELECT UPPER(employee_name)
FROM employees;
```

### `LOWER`

```sql
SELECT LOWER(employee_name)
FROM employees;
```

### `LENGTH`

```sql
SELECT employee_name,LENGTH(employee_name)
FROM employees;
```

### `TRIM`

```sql
SELECT TRIM(employee_name)
FROM employees;
```

### `CONCAT`

```sql
SELECT CONCAT(employee_name,' - ',department)
FROM employees;
```

### String Concatenation

```sql
SELECT employee_name||' - '||department
FROM employees;
```

### `SUBSTRING`

```sql
SELECT SUBSTRING(employee_name FROM 1 FOR 3)
FROM employees;
```

### `REPLACE`

```sql
SELECT REPLACE(employee_name,'a','A')
FROM employees;
```

---

# 10. Date & Time Functions

### Current Date

```sql
SELECT CURRENT_DATE;
```

### Current Timestamp

```sql
SELECT CURRENT_TIMESTAMP;
```

### Extract

```sql
SELECT
    employee_name,
    EXTRACT(YEAR FROM joining_date) AS joining_year
FROM employees;
```

### Date Difference

```sql
SELECT
    CURRENT_DATE-joining_date AS days_since_joining
FROM employees;
```

### Age

```sql
SELECT
    employee_name,
    AGE(CURRENT_DATE,joining_date) AS experience
FROM employees;
```

### Date Truncation

```sql
SELECT
    DATE_TRUNC('month',joining_date)
FROM employees;
```

---

# 11. Mathematical Functions

### `ROUND`

```sql
SELECT ROUND(125.567,2);
```

### `CEIL`

```sql
SELECT CEIL(125.2);
```

### `FLOOR`

```sql
SELECT FLOOR(125.8);
```

### `ABS`

```sql
SELECT ABS(-100);
```

### `POWER`

```sql
SELECT POWER(2,3);
```

### `MOD`

```sql
SELECT MOD(10,3);
```

---

# 12. UNION

`UNION` combines the results of two queries and removes duplicates.

### Syntax

```sql
SELECT ...
UNION
SELECT ...;
```

Example:

```sql
SELECT department
FROM employees
WHERE salary > 85000
UNION
SELECT department
FROM employees
WHERE salary < 70000;
```

---

# 13. UNION ALL

`UNION ALL` combines results while keeping duplicates.

```sql
SELECT department
FROM employees
WHERE salary > 85000
UNION ALL
SELECT department
FROM employees
WHERE salary < 70000;
```

---

# 14. INTERSECT

Returns rows present in both query results.

```sql
SELECT department
FROM employees
WHERE salary > 70000
INTERSECT
SELECT department
FROM employees
WHERE salary < 90000;
```

---

# 15. EXCEPT

Returns rows from the first query that are not present in the second.

```sql
SELECT department
FROM employees
WHERE salary > 70000
EXCEPT
SELECT department
FROM employees
WHERE salary > 90000;
```

---

# 16. DISTINCT ON

`DISTINCT ON` is PostgreSQL-specific.

It returns the first row for each distinct value.

### Syntax

```sql
SELECT DISTINCT ON(column)
    ...
FROM table
ORDER BY column,...;
```

Example:

```sql
SELECT DISTINCT ON(department)
    department,
    employee_name,
    salary
FROM employees
ORDER BY department,salary DESC;
```

This returns the highest-paid employee from each department.

---

# 17. INSERT ... RETURNING

`RETURNING` returns rows affected by an `INSERT`.

```sql
INSERT INTO employees(
    employee_name,
    department,
    salary,
    joining_date
)
VALUES(
    'Nikhil',
    'IT',
    82000,
    CURRENT_DATE
)
RETURNING *;
```

---

# 18. UPDATE ... RETURNING

```sql
UPDATE employees
SET salary=salary*1.10
WHERE department='IT'
RETURNING employee_id,employee_name,salary;
```

---

# 19. DELETE ... RETURNING

```sql
DELETE FROM employees
WHERE salary<65000
RETURNING *;
```

---

# 20. ON CONFLICT

`ON CONFLICT` handles duplicate or conflicting inserts.

### Ignore Conflict

```sql
INSERT INTO customers(
    customer_name,
    email
)
VALUES(
    'Aarav',
    'aarav@gmail.com'
)
ON CONFLICT(email)
DO NOTHING;
```

---

# 21. ON CONFLICT DO UPDATE

```sql
INSERT INTO customers(
    customer_name,
    email
)
VALUES(
    'Aarav',
    'aarav@gmail.com'
)
ON CONFLICT(email)
DO UPDATE
SET customer_name=EXCLUDED.customer_name;
```

`EXCLUDED` refers to the value proposed for insertion.

---

# 22. UPSERT

UPSERT means:

```text
INSERT
   ↓
If conflict
   ↓
UPDATE
```

Example:

```sql
INSERT INTO customers(
    customer_name,
    email
)
VALUES(
    'Aarav',
    'aarav@gmail.com'
)
ON CONFLICT(email)
DO UPDATE
SET customer_name=EXCLUDED.customer_name;
```

---

# 23. User-Defined Functions

A function is reusable database logic that can accept parameters and return a value or result set.

### Basic Syntax

```sql
CREATE FUNCTION function_name(parameters)
RETURNS datatype
LANGUAGE language
AS $$
BEGIN
    ...
    RETURN value;
END;
$$;
```

---

# 24. Simple Function

```sql
CREATE OR REPLACE FUNCTION add_numbers(a INT,b INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN a+b;
END;
$$;
```

Call the function:

```sql
SELECT add_numbers(10,20);
```

---

# 25. Function with Table Data

```sql
CREATE OR REPLACE FUNCTION get_employee_salary(emp_id INT)
RETURNS DECIMAL
LANGUAGE plpgsql
AS $$
DECLARE
    emp_salary DECIMAL;
BEGIN
    SELECT salary
    INTO emp_salary
    FROM employees
    WHERE employee_id=emp_id;

    RETURN emp_salary;
END;
$$;
```

Call:

```sql
SELECT get_employee_salary(1);
```

---

# 26. Function with IF

```sql
CREATE OR REPLACE FUNCTION salary_category(emp_salary DECIMAL)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    IF emp_salary>=90000 THEN
        RETURN 'High';
    ELSIF emp_salary>=70000 THEN
        RETURN 'Medium';
    ELSE
        RETURN 'Low';
    END IF;
END;
$$;
```

Call:

```sql
SELECT
    employee_name,
    salary_category(salary)
FROM employees;
```

---

# 27. Function Returning Table

### Syntax

```sql
CREATE FUNCTION function_name(...)
RETURNS TABLE(...)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT ...;
END;
$$;
```

Example:

```sql
CREATE OR REPLACE FUNCTION get_department_employees(dept VARCHAR)
RETURNS TABLE(
    employee_id INT,
    employee_name VARCHAR,
    salary DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.employee_id,
        e.employee_name,
        e.salary
    FROM employees e
    WHERE e.department=dept;
END;
$$;
```

Call:

```sql
SELECT *
FROM get_department_employees('IT');
```

---

# 28. Function Parameters

Functions can accept:

```text
IN
OUT
INOUT
```

Example:

```sql
CREATE OR REPLACE FUNCTION multiply_numbers(
    a INT,
    b INT
)
RETURNS INT
LANGUAGE SQL
AS $$
    SELECT a*b;
$$;
```

---

# 29. SQL Language Function

Functions do not always require `plpgsql`.

```sql
CREATE OR REPLACE FUNCTION get_total(a INT,b INT)
RETURNS INT
LANGUAGE SQL
AS $$
    SELECT a+b;
$$;
```

---

# 30. Stored Procedures

A procedure is a stored database routine invoked using `CALL`.

### Syntax

```sql
CREATE PROCEDURE procedure_name(parameters)
LANGUAGE plpgsql
AS $$
BEGIN
    ...
END;
$$;
```

---

# 31. Simple Procedure

```sql
CREATE OR REPLACE PROCEDURE update_employee_salary(
    emp_id INT,
    increase DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE employees
    SET salary=salary+increase
    WHERE employee_id=emp_id;
END;
$$;
```

Call:

```sql
CALL update_employee_salary(1,5000);
```

---

# 32. Procedure with IF

```sql
CREATE OR REPLACE PROCEDURE update_salary(
    emp_id INT,
    increase DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF increase>0 THEN
        UPDATE employees
        SET salary=salary+increase
        WHERE employee_id=emp_id;
    END IF;
END;
$$;
```

Call:

```sql
CALL update_salary(1,5000);
```

---

# 33. Function vs Procedure

| Function                                     | Procedure                                 |
| -------------------------------------------- | ----------------------------------------- |
| Called using `SELECT`                        | Called using `CALL`                       |
| Returns a value/result                       | Does not have to return a value           |
| Can be used inside SQL expressions           | Invoked as a statement                    |
| Useful for calculations and reusable queries | Useful for performing database operations |
| Can return tables                            | Can perform procedural operations         |

---

# 34. Practical Example

### Function

```sql
CREATE OR REPLACE FUNCTION get_annual_salary(
    monthly_salary DECIMAL
)
RETURNS DECIMAL
LANGUAGE SQL
AS $$
    SELECT monthly_salary*12;
$$;
```

```sql
SELECT
    employee_name,
    get_annual_salary(salary) AS annual_salary
FROM employees;
```

### Procedure

```sql
CREATE OR REPLACE PROCEDURE increase_department_salary(
    dept VARCHAR,
    increase DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE employees
    SET salary=salary+increase
    WHERE department=dept;
END;
$$;
```

```sql
CALL increase_department_salary('IT',5000);
```

---

# 35. Advanced SQL Quick Revision

```text
CASE
→ Conditional logic

COALESCE
→ First non-NULL value

NULLIF
→ NULL when two values are equal

CAST
→ Convert data type

FILTER
→ Conditional aggregate

UNION
→ Combine results + remove duplicates

UNION ALL
→ Combine results + keep duplicates

INTERSECT
→ Common rows

EXCEPT
→ Rows in first query but not second

DISTINCT ON
→ First row for each distinct value

ON CONFLICT
→ Handle duplicate conflicts

UPSERT
→ INSERT + UPDATE on conflict

RETURNING
→ Return affected rows
```

---

# 36. Functions & Procedures Quick Revision

```text
FUNCTION
→ Reusable database logic
→ Can return a value/result
→ Called using SELECT

PROCEDURE
→ Reusable database operation
→ Called using CALL
→ Does not require a return value
```

---
