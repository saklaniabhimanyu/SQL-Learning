# Day 7 — Advanced PostgreSQL

Day 7 focuses on advanced PostgreSQL features used for **automation, stored query results, temporary data processing, and database-level logic**.

---

## Topics Covered

### 1. Triggers

A **trigger** automatically executes a function when a specified database event occurs.

Common events:

* `INSERT`
* `UPDATE`
* `DELETE`
* `TRUNCATE`

Trigger timing:

* `BEFORE`
* `AFTER`
* `INSTEAD OF`

Trigger levels:

* Row-level
* Statement-level

---

## 2. Trigger Functions

PostgreSQL triggers execute a function.

### Basic Syntax

```sql
CREATE OR REPLACE FUNCTION function_name()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- logic
    RETURN NEW;
END;
$$;
```

---

## 3. CREATE TRIGGER

### Basic Syntax

```sql
CREATE TRIGGER trigger_name
BEFORE INSERT ON table_name
FOR EACH ROW
EXECUTE FUNCTION function_name();
```

---

## 4. BEFORE Triggers

A `BEFORE` trigger runs before the database operation.

Common uses:

* Data validation
* Automatically modifying values
* Setting default values
* Cleaning data

Example:

```sql
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();
```

---

## 5. AFTER Triggers

An `AFTER` trigger runs after the database operation succeeds.

Common uses:

* Audit logging
* Maintaining history tables
* Recording changes
* Synchronizing related data

Example:

```sql
CREATE TRIGGER employee_audit
AFTER UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION log_employee_change();
```

---

## 6. INSTEAD OF Triggers

`INSTEAD OF` triggers are primarily used with **views**.

They allow custom behavior instead of the normal operation.

```sql
CREATE TRIGGER update_employee_view
INSTEAD OF UPDATE ON employee_view
FOR EACH ROW
EXECUTE FUNCTION update_employee();
```

---

## 7. Row-Level Triggers

A row-level trigger executes once for every affected row.

```sql
CREATE TRIGGER employee_update
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION update_employee();
```

If 10 rows are updated, the trigger function executes 10 times.

---

## 8. Statement-Level Triggers

A statement-level trigger executes once for the entire SQL statement.

```sql
CREATE TRIGGER employee_update
AFTER UPDATE ON employees
FOR EACH STATEMENT
EXECUTE FUNCTION log_update();
```

If 10 rows are updated, the trigger function executes once.

---

## 9. OLD and NEW

Trigger functions provide special records:

### `NEW`

Represents the new row.

Commonly used with:

* `INSERT`
* `UPDATE`

```sql
NEW.salary
```

### `OLD`

Represents the previous row.

Commonly used with:

* `UPDATE`
* `DELETE`

```sql
OLD.salary
```

Example:

```sql
IF NEW.salary > OLD.salary THEN
    -- salary increased
END IF;
```

---

## 10. Common Trigger Use Cases

Triggers are commonly used for:

* Audit logs
* Automatically updating timestamps
* Data validation
* Maintaining history tables
* Enforcing business rules
* Automatically updating related records

Triggers should be used carefully because they execute automatically and can make database behavior less obvious.

---

# Materialized Views

## 11. What is a Materialized View?

A **materialized view** stores the result of a query physically.

Unlike a normal view, the query result is stored and can be reused without executing the underlying query every time.

Useful for:

* Large aggregations
* Reporting
* Analytics
* Dashboards
* Expensive queries

---

## 12. CREATE MATERIALIZED VIEW

### Basic Syntax

```sql
CREATE MATERIALIZED VIEW sales_summary AS
SELECT
    customer_id,
    SUM(amount) AS total_sales
FROM orders
GROUP BY customer_id;
```

Query it like a normal table:

```sql
SELECT *
FROM sales_summary;
```

---

## 13. Refresh Materialized View

Materialized views do not automatically reflect changes in the underlying tables.

Use:

```sql
REFRESH MATERIALIZED VIEW sales_summary;
```

to update the stored results.

---

## 14. REFRESH CONCURRENTLY

PostgreSQL supports concurrent refreshes when the required unique index exists.

```sql
CREATE UNIQUE INDEX sales_summary_customer_idx
ON sales_summary(customer_id);
```

Then:

```sql
REFRESH MATERIALIZED VIEW CONCURRENTLY sales_summary;
```

This can reduce blocking of reads while the materialized view is refreshed.

---

## 15. Materialized View vs View

| Feature                             | View                        | Materialized View          |
| ----------------------------------- | --------------------------- | -------------------------- |
| Stores query result                 | No                          | Yes                        |
| Data automatically reflects changes | Yes                         | No                         |
| Requires refresh                    | No                          | Yes                        |
| Query performance                   | Depends on underlying query | Often faster               |
| Storage required                    | No result storage           | Yes                        |
| Best for                            | Dynamic queries             | Expensive/repeated queries |

---

## 16. Drop Materialized View

```sql
DROP MATERIALIZED VIEW IF EXISTS sales_summary;
```

---

# Temporary Tables

## 17. What is a Temporary Table?

A **temporary table** exists only for the current database session.

It is useful for:

* Intermediate results
* Data transformation
* Multi-step analysis
* Staging data
* Complex query workflows

---

## 18. CREATE TEMP TABLE

```sql
CREATE TEMP TABLE temp_orders AS
SELECT *
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days';
```

Query it normally:

```sql
SELECT *
FROM temp_orders;
```

---

## 19. Temporary Table with Structure

```sql
CREATE TEMP TABLE temp_customers (
    customer_id INT,
    customer_name VARCHAR(100),
    total_spent DECIMAL(12,2)
);
```

Insert data:

```sql
INSERT INTO temp_customers
SELECT
    customer_id,
    first_name || ' ' || last_name,
    0
FROM customers;
```

---

## 20. Temporary Table Scope

Temporary tables are generally available only within the session that created them.

Other database sessions cannot directly access the same temporary table.

They are automatically removed when the session ends.

---

## 21. ON COMMIT Behavior

PostgreSQL allows temporary tables to define what happens at transaction commit.

### Preserve Rows

```sql
CREATE TEMP TABLE temp_data (
    id INT
) ON COMMIT PRESERVE ROWS;
```

### Delete Rows

```sql
CREATE TEMP TABLE temp_data (
    id INT
) ON COMMIT DELETE ROWS;
```

### Drop Table

```sql
CREATE TEMP TABLE temp_data (
    id INT
) ON COMMIT DROP;
```

---

## 22. Temporary Table vs CTE

| Feature                 | CTE                               | Temporary Table       |
| ----------------------- | --------------------------------- | --------------------- |
| Lifetime                | Query                             | Session               |
| Reusable across queries | No                                | Yes                   |
| Physically stored       | Usually not as a persistent table | Yes                   |
| Can be indexed          | No                                | Yes                   |
| Best for                | Single query logic                | Multi-step processing |

---

## 23. Temporary Table vs Materialized View

| Feature                 | Temporary Table      | Materialized View           |
| ----------------------- | -------------------- | --------------------------- |
| Lifetime                | Session              | Persistent                  |
| Stores data             | Yes                  | Yes                         |
| Automatically refreshed | No                   | No                          |
| Can be modified         | Yes                  | Not like a normal table     |
| Typical use             | Temporary processing | Repeated analytical queries |

---

# Key Syntax

### Triggers

```sql
CREATE OR REPLACE FUNCTION trigger_function()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN NEW;
END;
$$;

CREATE TRIGGER trigger_name
BEFORE INSERT ON table_name
FOR EACH ROW
EXECUTE FUNCTION trigger_function();
```

### Materialized Views

```sql
CREATE MATERIALIZED VIEW view_name AS
SELECT ...;

REFRESH MATERIALIZED VIEW view_name;

DROP MATERIALIZED VIEW view_name;
```

### Temporary Tables

```sql
CREATE TEMP TABLE table_name AS
SELECT ...;

DROP TABLE table_name;
```

---
