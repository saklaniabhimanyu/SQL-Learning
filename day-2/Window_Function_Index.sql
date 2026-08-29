CREATE TABLE employees(
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    joining_date DATE
);

INSERT INTO employees(employee_name,department,salary,joining_date)
VALUES
('Aarav','IT',85000,'2022-01-10'),
('Priya','IT',95000,'2021-05-15'),
('Rahul','IT',85000,'2023-03-20'),
('Sneha','IT',75000,'2024-07-11'),
('Arjun','HR',70000,'2022-02-18'),
('Ananya','HR',80000,'2021-08-25'),
('Vikram','HR',70000,'2023-09-14'),
('Kavya','HR',65000,'2024-01-05'),
('Rohan','Sales',90000,'2022-06-12'),
('Neha','Sales',85000,'2023-02-17'),
('Aditya','Sales',90000,'2021-11-09'),
('Pooja','Sales',70000,'2024-04-22');

SELECT * FROM employees;

-- WINDOW FUNCTIONS
SELECT employee_name,department,salary,AVG(salary) OVER() AS average_salary
FROM employees;

SELECT employee_name,department,salary,
AVG(salary) OVER(PARTITION BY department) AS department_average
FROM employees;

-- ROW_NUMBER
SELECT employee_name,department,salary,
ROW_NUMBER() OVER(ORDER BY salary DESC) AS row_number
FROM employees;

SELECT employee_name,department,salary,
ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS row_number
FROM employees;

-- RANK
SELECT employee_name,department,salary,
RANK() OVER(ORDER BY salary DESC) AS salary_rank
FROM employees;

SELECT employee_name,department,salary,
RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS salary_rank
FROM employees;

-- DENSE_RANK
SELECT employee_name,department,salary,
DENSE_RANK() OVER(ORDER BY salary DESC) AS salary_rank
FROM employees;

SELECT employee_name,salary,
ROW_NUMBER() OVER(ORDER BY salary DESC) AS row_number,
RANK() OVER(ORDER BY salary DESC) AS rank,
DENSE_RANK() OVER(ORDER BY salary DESC) AS dense_rank
FROM employees;

-- NTILE
SELECT employee_name,salary,
NTILE(4) OVER(ORDER BY salary DESC) AS salary_quartile
FROM employees;

-- LAG
SELECT employee_name,department,salary,
LAG(salary) OVER(ORDER BY salary DESC) AS previous_salary
FROM employees;

SELECT employee_name,department,salary,
LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS previous_salary
FROM employees;

-- LEAD
SELECT employee_name,department,salary,
LEAD(salary) OVER(ORDER BY salary DESC) AS next_salary
FROM employees;

SELECT employee_name,department,salary,
LEAD(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS next_salary
FROM employees;

-- FIRST_VALUE
SELECT employee_name,department,salary,
FIRST_VALUE(employee_name) OVER(PARTITION BY department ORDER BY salary DESC) AS highest_paid
FROM employees;

-- LAST_VALUE
SELECT employee_name,department,salary,
LAST_VALUE(employee_name) OVER(
    PARTITION BY department
    ORDER BY salary DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS lowest_paid
FROM employees;

-- AGGREGATE WINDOW FUNCTIONS
SELECT employee_name,department,salary,
COUNT(*) OVER() AS total_employees,
SUM(salary) OVER() AS total_salary,
AVG(salary) OVER() AS average_salary,
MIN(salary) OVER() AS minimum_salary,
MAX(salary) OVER() AS maximum_salary
FROM employees;

SELECT employee_name,department,salary,
COUNT(*) OVER(PARTITION BY department) AS department_count,
SUM(salary) OVER(PARTITION BY department) AS department_total,
AVG(salary) OVER(PARTITION BY department) AS department_average,
MIN(salary) OVER(PARTITION BY department) AS department_min,
MAX(salary) OVER(PARTITION BY department) AS department_max
FROM employees;

-- RUNNING TOTAL
SELECT employee_id,employee_name,salary,
SUM(salary) OVER(ORDER BY employee_id) AS running_total
FROM employees;

SELECT employee_name,department,salary,
SUM(salary) OVER(PARTITION BY department ORDER BY joining_date) AS running_total
FROM employees;

-- WINDOW FRAME
SELECT employee_name,salary,
SUM(salary) OVER(
    ORDER BY employee_id
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS running_total
FROM employees;

-- TOP N PER GROUP
SELECT *
FROM(
    SELECT employee_name,department,salary,
    ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS rn
    FROM employees
) ranked
WHERE rn<=2;

SELECT *
FROM(
    SELECT employee_name,department,salary,
    DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS salary_rank
    FROM employees
) ranked
WHERE salary_rank<=3;

-- SALARY VS DEPARTMENT AVERAGE
SELECT employee_name,department,salary,
AVG(salary) OVER(PARTITION BY department) AS department_average,
salary-AVG(salary) OVER(PARTITION BY department) AS difference
FROM employees;

-- SALARY DIFFERENCE USING LAG
SELECT employee_name,department,salary,
LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS previous_salary,
salary-LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS salary_difference
FROM employees;

-- VIEWS
CREATE VIEW active_customers AS
SELECT customer_id,first_name,last_name,email,account_balance
FROM customers
WHERE is_active=TRUE;

SELECT * FROM active_customers;

CREATE OR REPLACE VIEW active_customers AS
SELECT customer_id,first_name,last_name,email,account_balance,created_at
FROM customers
WHERE is_active=TRUE;

DROP VIEW IF EXISTS active_customers;

CREATE VIEW customer_orders AS
SELECT
c.customer_id,
c.first_name||' '||c.last_name AS customer_name,
o.order_id,
o.order_date,
o.quantity,
p.product_name,
p.price,
o.quantity*p.price AS order_value
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN products p ON o.product_id=p.product_id;

SELECT * FROM customer_orders;

CREATE VIEW customer_spending AS
SELECT
c.customer_id,
c.first_name||' '||c.last_name AS customer_name,
SUM(o.quantity*p.price) AS total_spending
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN products p ON o.product_id=p.product_id
GROUP BY c.customer_id,c.first_name,c.last_name;

SELECT * FROM customer_spending
ORDER BY total_spending DESC;

-- INDEXES
CREATE INDEX idx_customers_email
ON customers(email);

CREATE INDEX idx_customers_last_name
ON customers(last_name);

CREATE INDEX idx_customer_name
ON customers(first_name,last_name);

CREATE INDEX idx_active_customers
ON customers(customer_id)
WHERE is_active=TRUE;

CREATE INDEX idx_orders_customer_id
ON orders(customer_id);

CREATE INDEX idx_orders_product_id
ON orders(product_id);

DROP INDEX IF EXISTS idx_customers_last_name;

-- EXPLAIN
EXPLAIN
SELECT *
FROM customers
WHERE email='aarav.sharma@gmail.com';

-- EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT *
FROM customers
WHERE email='aarav.sharma@gmail.com';

EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE customer_id=1;