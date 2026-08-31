# Day 4 - Database Design & Normalization

Day 4 covers the fundamentals of **relational database design, keys, relationships, functional dependencies, anomalies, and normalization**.

**Database:** PostgreSQL

---

#  Topics Covered

* Database Design
* Data Redundancy
* Data Anomalies

  * Insert Anomaly
  * Update Anomaly
  * Delete Anomaly
* Functional Dependencies
* Keys

  * Super Key
  * Candidate Key
  * Primary Key
  * Alternate Key
  * Foreign Key
  * Composite Key
* Entity Relationships

  * One-to-One
  * One-to-Many
  * Many-to-Many
* First Normal Form — 1NF
* Second Normal Form — 2NF
* Third Normal Form — 3NF
* Boyce-Codd Normal Form — BCNF
* Denormalization
* Normalization vs Denormalization
* Practical Database Design

---

# 1. Database Design

Database design is the process of organizing data into tables and defining relationships between those tables.

A good database design should:

* Minimize data redundancy
* Prevent data anomalies
* Maintain data consistency
* Clearly represent relationships
* Make data easy to query and maintain
* Enforce data integrity

Example:

Instead of storing everything in one table:

```text
Student
------------------------------------------------
student_id
student_name
course_name
instructor_name
instructor_email
```

we can separate related entities:

```text
Students
Courses
Instructors
Enrollments
```

---

# 2. Data Redundancy

**Data redundancy** means storing the same information unnecessarily in multiple places.

Example:

```text
student_id | student_name | course | instructor | instructor_email
-----------|--------------|--------|------------|-------------------
1          | Aarav        | DBMS   | Rahul      | rahul@gmail.com
2          | Priya        | DBMS   | Rahul      | rahul@gmail.com
3          | Rohan        | DBMS   | Rahul      | rahul@gmail.com
```

The instructor's information is repeated for every student.

This can cause:

* Wasted storage
* Inconsistent data
* Update problems
* Maintenance problems

Normalization helps reduce redundancy.

---

# 3. Data Anomalies

Poor database design can cause three major anomalies:

```text
INSERT ANOMALY
UPDATE ANOMALY
DELETE ANOMALY
```

---

# 4. Insert Anomaly

An **insert anomaly** occurs when we cannot insert information without also inserting unrelated information.

Example:

```text
student_id | student_name | course
-----------|--------------|-------
1          | Aarav        | DBMS
```

Suppose a new course `AI` is created but no student has enrolled yet.

If the table requires a `student_id`, we may not be able to store the course independently.

Separating students and courses solves this problem.

---

# 5. Update Anomaly

An **update anomaly** occurs when the same information is stored in multiple rows and must be updated everywhere.

Example:

```text
student_id | course | instructor | instructor_email
-----------|--------|------------|------------------
1          | DBMS   | Rahul      | old@gmail.com
2          | DBMS   | Rahul      | old@gmail.com
3          | DBMS   | Rahul      | old@gmail.com
```

If Rahul changes his email, multiple rows must be updated.

If one row is missed:

```text
old@gmail.com
new@gmail.com
```

the database becomes inconsistent.

---

# 6. Delete Anomaly

A **delete anomaly** occurs when deleting one piece of information accidentally removes another useful piece of information.

Example:

```text
student_id | student_name | course
-----------|--------------|-------
1          | Aarav        | DBMS
2          | Priya        | AI
```

If Priya is the only student enrolled in AI and her row is deleted, information about the AI course may also be lost.

Separating entities prevents this problem.

---

# 7. Keys

Keys are used to identify records and establish relationships between tables.

---

# 8. Super Key

A **super key** is any set of one or more attributes that can uniquely identify a row.

Example:

```text
student_id
```

could uniquely identify a student.

So can:

```text
student_id + student_name
```

although `student_name` is unnecessary.

Both can be super keys.

---

# 9. Candidate Key

A **candidate key** is a minimal super key.

It uniquely identifies a row and contains no unnecessary attributes.

Example:

```text
student_id
email
```

If both uniquely identify students, both are candidate keys.

---

# 10. Primary Key

A **primary key** is the candidate key chosen to uniquely identify rows.

Example:

```sql
CREATE TABLE students(
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    email VARCHAR(255)
);
```

Properties:

* Unique
* Cannot be `NULL`
* One primary key constraint per table
* Can contain multiple columns

---

# 11. Alternate Key

Candidate keys that are **not selected as the primary key** are alternate keys.

Example:

```text
Candidate Keys:
student_id
email

Primary Key:
student_id

Alternate Key:
email
```

---

# 12. Composite Key

A **composite key** contains more than one column.

Example:

```sql
CREATE TABLE enrollments(
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    PRIMARY KEY(student_id,course_id)
);
```

The combination:

```text
student_id + course_id
```

uniquely identifies an enrollment.

---

# 13. Foreign Key

A foreign key references a key in another table.

Example:

```sql
CREATE TABLE courses(
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100)
);

CREATE TABLE enrollments(
    student_id INT,
    course_id INT,
    FOREIGN KEY(course_id)
        REFERENCES courses(course_id)
);
```

Foreign keys maintain **referential integrity**.

---

# 14. Entity Relationships

Tables can have different types of relationships.

### One-to-One

One record in Table A corresponds to one record in Table B.

```text
Person
  1
  |
  1
Passport
```

Example:

```text
Person → Passport
```

---

# 15. One-to-Many

One record can be related to many records.

```text
Customer
   1
   |
   ∞
Orders
```

Example:

One customer can place many orders.

This is one of the most common relational database relationships.

---

# 16. Many-to-Many

Many records in Table A can relate to many records in Table B.

Example:

```text
Students ←→ Courses
```

A student can take multiple courses.

A course can have multiple students.

A many-to-many relationship is normally implemented using a **junction/associative table**.

```text
Students
    |
    |
Enrollments
    |
    |
Courses
```

Example:

```sql
CREATE TABLE enrollments(
    student_id INT,
    course_id INT,
    PRIMARY KEY(student_id,course_id),
    FOREIGN KEY(student_id) REFERENCES students(student_id),
    FOREIGN KEY(course_id) REFERENCES courses(course_id)
);
```

---

# 17. Functional Dependency

A functional dependency describes a relationship between attributes.

Notation:

```text
A → B
```

means:

> If we know A, we can determine B.

Example:

```text
student_id → student_name
```

A student's ID determines their name.

Another example:

```text
course_id → course_name
```

A course ID determines the course name.

---

# 18. Partial Dependency

A partial dependency occurs when a non-key attribute depends on **part of a composite key**, rather than the entire key.

Example:

```text
(student_id, course_id) → grade
student_id → student_name
course_id → course_name
```

If the primary key is:

```text
(student_id, course_id)
```

then:

```text
student_id → student_name
```

is a partial dependency.

Partial dependencies are removed in **2NF**.

---

# 19. Transitive Dependency

A transitive dependency occurs when a non-key attribute depends on another non-key attribute.

Example:

```text
student_id → department_id
department_id → department_name
```

Therefore:

```text
student_id → department_name
```

indirectly.

This is a transitive dependency.

Transitive dependencies are removed in **3NF**.

---

# 20. First Normal Form — 1NF

A table is in **1NF** when:

* Each cell contains a single atomic value
* There are no repeating groups
* Each row can be uniquely identified

---

## Not in 1NF

```text
student_id | student_name | phone_numbers
-----------|--------------|-------------------
1          | Aarav        | 9876, 8765
```

The `phone_numbers` column contains multiple values.

---

## Convert to 1NF

```text
student_id | student_name | phone
-----------|--------------|------
1          | Aarav        | 9876
1          | Aarav        | 8765
```

Or, depending on the design:

```text
Students
--------
student_id
student_name

Student_Phones
--------------
student_id
phone
```

Each cell now contains a single value.

---

# 21. Second Normal Form — 2NF

A table is in **2NF** when:

1. It is already in 1NF
2. There are no partial dependencies

2NF mainly matters when a table has a **composite key**.

---

## Example

Consider:

```text
Enrollment
------------------------------------------------
student_id
course_id
student_name
course_name
grade
```

Primary key:

```text
(student_id,course_id)
```

Dependencies:

```text
student_id → student_name
course_id → course_name
(student_id,course_id) → grade
```

`student_name` depends only on `student_id`.

`course_name` depends only on `course_id`.

These are partial dependencies.

---

# 22. Convert to 2NF

Split the table:

```text
Students
----------------
student_id
student_name
```

```text
Courses
----------------
course_id
course_name
```

```text
Enrollments
----------------
student_id
course_id
grade
```

Now non-key attributes depend on the complete key of their table.

---

# 23. Third Normal Form — 3NF

A table is in **3NF** when:

1. It is already in 2NF
2. It has no transitive dependencies

In simple terms:

> Non-key attributes should depend on the key, the whole key, and nothing but the key.

---

# 24. Example of Transitive Dependency

Consider:

```text
Employees
------------------------------------
employee_id
employee_name
department_id
department_name
```

Dependencies:

```text
employee_id → department_id
department_id → department_name
```

Therefore:

```text
employee_id → department_name
```

`department_name` indirectly depends on `employee_id`.

This is a transitive dependency.

---

# 25. Convert to 3NF

Separate the department information:

```text
Employees
----------------
employee_id
employee_name
department_id
```

```text
Departments
----------------
department_id
department_name
```

Now:

```text
employee_id → employee_name
employee_id → department_id

department_id → department_name
```

The transitive dependency has been removed.

---

# 26. BCNF — Boyce-Codd Normal Form

BCNF is a stronger version of 3NF.

A relation is in BCNF when:

> Every determinant is a candidate key.

In other words, whenever:

```text
A → B
```

then `A` must be a candidate key.

---

# 27. 3NF vs BCNF

```text
3NF
→ Every non-key attribute depends on the key
→ Allows some cases that BCNF does not

BCNF
→ Every determinant must be a candidate key
→ Stronger than 3NF
```

Therefore:

```text
BCNF ⟹ 3NF
```

but generally:

```text
3NF ⇏ BCNF
```

---

# 28. Normalization Summary

```text
UNNORMALIZED
      ↓
     1NF
      ↓
     2NF
      ↓
     3NF
      ↓
    BCNF
```

### 1NF

Remove:

```text
Repeating groups
Non-atomic values
```

### 2NF

Remove:

```text
Partial dependencies
```

### 3NF

Remove:

```text
Transitive dependencies
```

### BCNF

Ensure:

```text
Every determinant is a candidate key
```

---

# 29. Normalization Example

### Unnormalized

```text
Order
-------------------------------------------------------
order_id | customer | products
-------------------------------------------------------
101      | Aarav    | Laptop, Mouse, Keyboard
```

Problems:

* Multiple values in one cell
* Difficult to query
* Data redundancy

---

### 1NF

```text
order_id | customer | product
---------|----------|----------
101      | Aarav    | Laptop
101      | Aarav    | Mouse
101      | Aarav    | Keyboard
```

Values are atomic.

---

### Better Design

```text
Customers
----------------
customer_id
customer_name
```

```text
Orders
----------------
order_id
customer_id
```

```text
Products
----------------
product_id
product_name
```

```text
Order_Items
----------------
order_id
product_id
quantity
```

This separates different entities and relationships.

---

# 30. Normalization Benefits

Normalization helps:

* Reduce redundancy
* Improve consistency
* Prevent anomalies
* Improve data integrity
* Make updates safer
* Create clear relationships

---

# 31. Disadvantages of Excessive Normalization

Highly normalized databases can require many joins.

This can:

* Make queries more complex
* Increase the number of tables
* Increase join operations
* Sometimes affect read performance

Therefore, database design is a balance between:

```text
Data Integrity
        +
Maintainability
        +
Performance
```

---

# 32. Denormalization

**Denormalization** intentionally introduces some redundancy to improve performance or simplify queries.

Example:

Instead of calculating customer totals through multiple joins every time, a system may store:

```text
customer_id
customer_name
total_spending
```

The stored value must then be maintained correctly.

---

# 33. Normalization vs Denormalization

| Normalization                   | Denormalization                         |
| ------------------------------- | --------------------------------------- |
| Reduces redundancy              | Introduces controlled redundancy        |
| Improves consistency            | Can improve read performance            |
| More tables                     | Fewer joins in some queries             |
| More joins may be required      | Less querying complexity in some cases  |
| Common in transactional systems | Common in analytical/read-heavy systems |

---

# 34. Practical Database Design

A common design process:

```text
Requirements
     ↓
Identify Entities
     ↓
Identify Attributes
     ↓
Identify Relationships
     ↓
Choose Keys
     ↓
Define Constraints
     ↓
Normalize
     ↓
Create Tables
     ↓
Add Indexes
     ↓
Test with Real Queries
```

---

# 35. Example Database Design

For an e-commerce system:

### Entities

```text
Customer
Product
Order
Order_Item
Category
```

### Relationships

```text
Customer
   |
   | 1:N
   ↓
Order
   |
   | 1:N
   ↓
Order_Item
   |
   | N:1
   ↓
Product
   |
   | N:1
   ↓
Category
```

---

# 36. Example Schema

```sql
CREATE TABLE customers(
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE categories(
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE products(
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT REFERENCES categories(category_id),
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE orders(
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE NOT NULL
);

CREATE TABLE order_items(
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL,
    PRIMARY KEY(order_id,product_id)
);
```

---

# 37. Key Revision

```text
REDUNDANCY
→ Unnecessary repeated data

INSERT ANOMALY
→ Cannot insert data independently

UPDATE ANOMALY
→ Same information must be updated in multiple rows

DELETE ANOMALY
→ Deleting one record unintentionally removes useful information
```

```text
SUPER KEY
→ Any attribute set that uniquely identifies a row

CANDIDATE KEY
→ Minimal super key

PRIMARY KEY
→ Selected candidate key

ALTERNATE KEY
→ Candidate key not chosen as primary

COMPOSITE KEY
→ Key made from multiple columns

FOREIGN KEY
→ References a key in another table
```

```text
1NF
→ Atomic values

2NF
→ 1NF + no partial dependency

3NF
→ 2NF + no transitive dependency

BCNF
→ Every determinant is a candidate key
```

---

# 38. Revise

### What is normalization?

Normalization is the process of organizing data into related tables to reduce redundancy and prevent data anomalies.

### What are the three major anomalies?

```text
Insert
Update
Delete
```

### What is the difference between 1NF, 2NF and 3NF?

```text
1NF → Atomic values
2NF → Removes partial dependencies
3NF → Removes transitive dependencies
```

### What is a candidate key?

A minimal set of attributes that uniquely identifies a row.

### What is a composite key?

A key consisting of two or more columns.

### What is the difference between primary key and foreign key?

```text
Primary Key
→ Identifies a row in its own table

Foreign Key
→ References a key in another table
```

### What is BCNF?

BCNF is a stronger form of 3NF where every determinant must be a candidate key.

### Why normalize a database?

To reduce redundancy, prevent anomalies, and maintain data consistency.

### Why denormalize?

To intentionally introduce controlled redundancy when it improves performance or simplifies frequently used queries.
* Analytical queries
* Business-oriented questions
