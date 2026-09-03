# SQL Revision & Practice

* Author - Abhimanyu Saklani

A structured PostgreSQL revision repository covering **SQL fundamentals, advanced querying, database design, transactions, and advanced PostgreSQL features**.

The goal of this repository is to build a strong foundation in SQL and progressively move toward advanced querying, database design, performance, and real-world database problem solving.

---

## Learning Roadmap

| Day   | Topics                                                                                  | Status    |
| ----- | --------------------------------------------------------------------------------------- | --------- |
| Day 1 | SQL Basics, DDL, DML, SELECT, Filtering, Sorting, Aggregations, GROUP BY, HAVING, Joins | Completed |
| Day 2 | Window Functions, Views, Indexes                                                        | Completed |
| Day 3 | CTEs, Subqueries                                                                        | Completed |
| Day 4 | Database Normalization & Database Design                                                | Completed |
| Day 5 | SQL Functions, Procedures, UPSERT & Advanced SQL Operations                             | Completed |
| Day 6 | Transactions & ACID Properties                                                          | Completed |
| Day 7 | Triggers, Materialized Views & Temporary Tables                                         | Completed |

---

# 📂 Repository Structure

```text
SQL/
│
├── README.md
│
├── day-1/
│   ├── sql-basics.sql
│   └── README.md
│
├── day-2/
│   ├── window-functions-views-indexes.sql
│   └── README.md
│
├── day-3/
│   ├── cte-subqueries.sql
│   └── README.md
│
├── day-4/
│   ├── normalization.sql
│   └── README.md
│
├── day-5/
│   ├── functions-procedures-upsert.sql
│   └── README.md
│
├── day-6/
│   ├── transactions-acid.sql
│   └── README.md
│
└── day-7/
    ├── triggers-materialized-views-temp-tables.sql
    └── README.md
```

Each day contains:

* **SQL file** → Queries, examples, and practice
* **README.md** → Concepts, syntax, explanations, and important notes
---

# Day 1 — SQL Basics

### Topics Covered

* Introduction to SQL
* Database fundamentals
* Tables, rows, columns
* DDL — Data Definition Language

  * `CREATE`
  * `ALTER`
  * `DROP`
  * `TRUNCATE`
* DML — Data Manipulation Language

  * `INSERT`
  * `UPDATE`
  * `DELETE`
* DQL

  * `SELECT`
* Filtering

  * `WHERE`
  * `AND`
  * `OR`
  * `BETWEEN`
  * `IS NULL`
  * `IS NOT NULL`
  * `LIKE`
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
* Joins

  * `INNER JOIN`
  * `LEFT JOIN`
  * `RIGHT JOIN`
  * `FULL OUTER JOIN`
  * `CROSS JOIN`
  * `SELF JOIN`
* Primary Keys
* Foreign Keys
* Constraints

---

# Day 2 — Window Functions, Views & Indexes

### Topics

* Window Functions

  * `ROW_NUMBER()`
  * `RANK()`
  * `DENSE_RANK()`
  * `NTILE()`
  * `LAG()`
  * `LEAD()`
  * `FIRST_VALUE()`
  * `LAST_VALUE()`
  * `PARTITION BY`
  * `ORDER BY` inside windows
  * Window frames
  * Running totals
  * Top-N per group
  * Aggregate window functions
* Views

  * Creating views
  * Replacing views
  * Dropping views
  * Views with joins
  * Views with aggregation
* Indexes

  * Creating indexes
  * Composite indexes
  * Partial indexes
  * Unique indexes
  * Dropping indexes
  * Index benefits and drawbacks
* Query Performance

  * `EXPLAIN`
  * `EXPLAIN ANALYZE`

---

# Day 3 — CTEs & Subqueries

### Topics

* Subqueries

  * Scalar subqueries
  * Single-row subqueries
  * Multi-row subqueries
  * Subqueries in `WHERE`
  * Subqueries in `SELECT`
  * Subqueries in `FROM`
  * Subqueries in `HAVING`
  * Correlated subqueries
  * Nested subqueries
  * `IN`
  * `NOT IN`
  * `EXISTS`
  * `NOT EXISTS`
  * `ANY`
  * `ALL`
* Common Table Expressions

  * `WITH`
  * Multiple CTEs
  * CTEs with joins
  * CTEs with aggregation
  * CTEs with window functions
  * Recursive CTEs
* CTE vs Subquery
* CTE vs Temporary Table
* Practical SQL interview patterns

---

# Day 4 — Database Design & Normalization

### Topics

* Database Design
* Data Redundancy
* Functional Dependencies
* Data Anomalies

  * Insert anomaly
  * Update anomaly
  * Delete anomaly
* Keys

  * Super Keys
  * Candidate Keys
  * Primary Keys
  * Alternate Keys
  * Composite Keys
  * Foreign Keys
* Normalization

  * 1NF — First Normal Form
  * 2NF — Second Normal Form
  * 3NF — Third Normal Form
  * BCNF
* Partial Dependency
* Transitive Dependency
* Relationships

  * One-to-One
  * One-to-Many
  * Many-to-Many
* Entity-Relationship concepts
* Normalization vs Denormalization
* Practical relational schema design

---
# Day 5 — SQL Functions, Procedures & UPSERT

### Topics

* Conditional Expressions

  * `CASE`
  * `COALESCE`
  * `NULLIF`
  * `CAST`
* String Functions
* Date & Time Functions
* Mathematical Functions
* Conditional Aggregation
* `FILTER`
* Set Operations

  * `UNION`
  * `UNION ALL`
  * `INTERSECT`
  * `EXCEPT`
* PostgreSQL `DISTINCT ON`
* `RETURNING`

  * `INSERT ... RETURNING`
  * `UPDATE ... RETURNING`
  * `DELETE ... RETURNING`
* `ON CONFLICT`
* UPSERT
* User-Defined Functions

  * `CREATE FUNCTION`
  * Function parameters
  * Return values
  * SQL functions
  * PL/pgSQL functions
  * Table-returning functions
* Stored Procedures

  * `CREATE PROCEDURE`
  * Parameters
  * `CALL`
* Functions vs Procedures

---

# Day 6 — Transactions & ACID

### Topics

* Database Transactions
* Transaction Lifecycle
* `BEGIN`
* `COMMIT`
* `ROLLBACK`
* `SAVEPOINT`
* `ROLLBACK TO SAVEPOINT`
* `RELEASE SAVEPOINT`
* ACID Properties

  * Atomicity
  * Consistency
  * Isolation
  * Durability
* Transaction Isolation Levels

  * `READ COMMITTED`
  * `REPEATABLE READ`
  * `SERIALIZABLE`
* Concurrency
* Transaction Conflicts
* Dirty Reads
* Non-Repeatable Reads
* Phantom Reads
* Lost Updates
* Row-Level Locking

  * `FOR UPDATE`
  * `FOR SHARE`
* Autocommit

---

# Day 7 — Advanced PostgreSQL

### Topics

* Triggers

  * `CREATE TRIGGER`
  * `CREATE FUNCTION` for triggers
  * `BEFORE` triggers
  * `AFTER` triggers
  * `INSTEAD OF` triggers
  * Row-level triggers
  * Statement-level triggers
  * `OLD` and `NEW`
  * Trigger use cases
  * Dropping triggers
* Materialized Views

  * `CREATE MATERIALIZED VIEW`
  * `REFRESH MATERIALIZED VIEW`
  * Materialized views vs views
  * Indexes on materialized views
  * Dropping materialized views
* Temporary Tables

  * `CREATE TEMP TABLE`
  * Temporary table scope
  * Temporary tables with queries
  * Temporary tables vs CTEs
  * Temporary tables vs regular tables
  * Dropping temporary tables

---

# Learning Goals

By completing this repository, I aim to be able to:

* Write SQL queries confidently
* Design normalized relational databases
* Work with multiple related tables
* Perform data aggregation and analysis
* Write complex queries using CTEs and subqueries
* Use window functions for analytical problems
* Create and use SQL functions and procedures
* Handle UPSERT and advanced DML operations
* Understand database transactions and ACID properties
* Understand indexes and query performance
* Work with PostgreSQL triggers
* Use materialized views for stored query results
* Work with temporary tables
* Solve SQL interview problems
* Apply PostgreSQL to real-world datasets and projects

---

# Database

The examples and practice queries in this repository primarily use:

**PostgreSQL**

Some syntax may differ between PostgreSQL, MySQL, SQL Server, and Oracle.

---

# Progress

```text
Day 1  ████████████  SQL Fundamentals
Day 2  ████████████  Window Functions / Views / Indexes
Day 3  ████████████  CTEs / Subqueries
Day 4  ████████████  Normalization / Database Design
Day 5  ████████████  Functions / Procedures / UPSERT
Day 6  ████████████  Transactions / ACID
Day 7  ████████████  Triggers / Materialized Views / Temp Tables
```

---

## Approach

This repository follows a **learn → write → practice → apply** approach.

Each topic is documented with:

1. Concept
2. Syntax
3. Example
4. Practice queries
5. Real-world use cases

The repository focuses on **SQL revision and PostgreSQL concepts**

---
## Progress Tracking

* [x] Repository setup
* [x] Day 1 — SQL Basics
* [x] Day 2 — Window Functions, Views & Indexes
* [x] Day 3 — CTEs & Subqueries
* [x] Day 4 — Normalization & Database Design
* [x] Day 5 — Functions, Procedures & UPSERT
* [x] Day 6 — Transactions & ACID
* [x] Day 7 — Triggers, Materialized Views & Temporary Tables 
