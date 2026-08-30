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

-- SUBQUERY IN WHERE

SELECT employee_name,salary
FROM employees
WHERE salary>(
    SELECT AVG(salary)
    FROM employees
);

SELECT *
FROM employees
WHERE salary=(
    SELECT MAX(salary)
    FROM employees
);

SELECT *
FROM employees
WHERE salary<(
    SELECT AVG(salary)
    FROM employees
);

-- SCALAR SUBQUERY

SELECT
    employee_name,
    salary,
    (SELECT AVG(salary) FROM employees) AS average_salary
FROM employees;

SELECT
    employee_name,
    salary,
    salary-(SELECT AVG(salary) FROM employees) AS difference
FROM employees;

-- SUBQUERY IN SELECT

SELECT
    employee_name,
    department,
    salary,
    (SELECT MAX(salary) FROM employees) AS highest_salary
FROM employees;

-- SUBQUERY IN FROM

SELECT *
FROM(
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department
) department_salary;

SELECT department,average_salary
FROM(
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department
) department_salary
WHERE average_salary>75000;

-- SUBQUERY IN HAVING

SELECT
    department,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department
HAVING AVG(salary)>(
    SELECT AVG(salary)
    FROM employees
);

-- IN

SELECT *
FROM employees
WHERE department IN(
    SELECT department
    FROM employees
    WHERE salary>90000
);

-- NOT IN

SELECT *
FROM employees
WHERE department NOT IN(
    SELECT department
    FROM employees
    WHERE salary>90000
);

-- EXISTS

SELECT
    c.customer_id,
    c.first_name
FROM customers c
WHERE EXISTS(
    SELECT 1
    FROM orders o
    WHERE o.customer_id=c.customer_id
);

-- NOT EXISTS

SELECT
    c.customer_id,
    c.first_name
FROM customers c
WHERE NOT EXISTS(
    SELECT 1
    FROM orders o
    WHERE o.customer_id=c.customer_id
);

-- CORRELATED SUBQUERY

SELECT
    e.employee_name,
    e.department,
    e.salary
FROM employees e
WHERE e.salary>(
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department=e.department
);

SELECT
    e.employee_name,
    e.department,
    e.salary
FROM employees e
WHERE e.salary=(
    SELECT MAX(e2.salary)
    FROM employees e2
    WHERE e2.department=e.department
);

-- NESTED SUBQUERY

SELECT *
FROM employees
WHERE salary=(
    SELECT MAX(salary)
    FROM employees
    WHERE salary<(
        SELECT MAX(salary)
        FROM employees
    )
);

-- ANY

SELECT *
FROM employees
WHERE salary>ANY(
    SELECT salary
    FROM employees
    WHERE department='HR'
);

SELECT *
FROM employees
WHERE salary=ANY(
    SELECT salary
    FROM employees
    WHERE department='HR'
);

-- ALL

SELECT *
FROM employees
WHERE salary>ALL(
    SELECT salary
    FROM employees
    WHERE department='HR'
);

-- CTE

WITH high_salary AS(
    SELECT *
    FROM employees
    WHERE salary>80000
)
SELECT *
FROM high_salary;

WITH department_salary AS(
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department
)
SELECT *
FROM department_salary;

-- CTE WITH WHERE

WITH department_salary AS(
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department
)
SELECT *
FROM department_salary
WHERE average_salary>75000;

-- MULTIPLE CTE

WITH department_avg AS(
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department
),
department_count AS(
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
ON a.department=c.department;

-- CTE WITH JOIN

WITH customer_orders AS(
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
ON c.customer_id=co.customer_id;

-- CTE WITH AGGREGATION

WITH customer_spending AS(
    SELECT
        o.customer_id,
        SUM(o.quantity*p.price) AS total_spending
    FROM orders o
    JOIN products p
    ON o.product_id=p.product_id
    GROUP BY o.customer_id
)
SELECT *
FROM customer_spending
WHERE total_spending>20000;

-- CTE WITH WINDOW FUNCTION

WITH ranked_employees AS(
    SELECT
        employee_name,
        department,
        salary,
        ROW_NUMBER() OVER(
            PARTITION BY department
            ORDER BY salary DESC
        ) AS rn
    FROM employees
)
SELECT *
FROM ranked_employees
WHERE rn<=2;

-- MULTIPLE CTE WITH WINDOW FUNCTION

WITH department_salary AS(
    SELECT
        department,
        employee_name,
        salary,
        AVG(salary) OVER(
            PARTITION BY department
        ) AS department_average
    FROM employees
),
ranked_employees AS(
    SELECT
        employee_name,
        department,
        salary,
        department_average,
        RANK() OVER(
            PARTITION BY department
            ORDER BY salary DESC
        ) AS salary_rank
    FROM department_salary
)
SELECT *
FROM ranked_employees
WHERE salary>department_average;

-- RECURSIVE CTE

WITH RECURSIVE numbers AS(
    SELECT 1 AS number
    UNION ALL
    SELECT number+1
    FROM numbers
    WHERE number<10
)
SELECT *
FROM numbers;

-- RECURSIVE CTE

CREATE TABLE employee_hierarchy(
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    manager_id INT
);

INSERT INTO employee_hierarchy(employee_id,employee_name,manager_id)
VALUES
(1,'CEO',NULL),
(2,'Manager A',1),
(3,'Manager B',1),
(4,'Developer A',2),
(5,'Developer B',2),
(6,'Developer C',3);

WITH RECURSIVE hierarchy AS(
    SELECT
        employee_id,
        employee_name,
        manager_id,
        1 AS level
    FROM employee_hierarchy
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.employee_id,
        e.employee_name,
        e.manager_id,
        h.level+1
    FROM employee_hierarchy e
    JOIN hierarchy h
    ON e.manager_id=h.employee_id
)
SELECT *
FROM hierarchy
ORDER BY level,employee_id;

-- SECOND HIGHEST SALARY

SELECT MAX(salary) AS second_highest
FROM employees
WHERE salary<(
    SELECT MAX(salary)
    FROM employees
);

SELECT *
FROM employees
WHERE salary=(
    SELECT MAX(salary)
    FROM employees
    WHERE salary<(
        SELECT MAX(salary)
        FROM employees
    )
);

-- SECOND HIGHEST DISTINCT SALARY

SELECT salary
FROM employees
GROUP BY salary
ORDER BY salary DESC
OFFSET 1
LIMIT 1;

-- EMPLOYEES ABOVE DEPARTMENT AVERAGE

SELECT
    e.employee_name,
    e.department,
    e.salary
FROM employees e
WHERE e.salary>(
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department=e.department
);

WITH department_avg AS(
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
ON e.department=d.department
WHERE e.salary>d.average_salary;

-- HIGHEST PAID EMPLOYEE IN EACH DEPARTMENT

SELECT
    e.employee_name,
    e.department,
    e.salary
FROM employees e
WHERE e.salary=(
    SELECT MAX(e2.salary)
    FROM employees e2
    WHERE e2.department=e.department
);

-- CUSTOMERS WITH ORDERS

SELECT
    c.customer_id,
    c.first_name
FROM customers c
WHERE EXISTS(
    SELECT 1
    FROM orders o
    WHERE o.customer_id=c.customer_id
);

SELECT DISTINCT
    c.customer_id,
    c.first_name
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id;

-- CUSTOMERS WITHOUT ORDERS

SELECT
    c.customer_id,
    c.first_name
FROM customers c
WHERE NOT EXISTS(
    SELECT 1
    FROM orders o
    WHERE o.customer_id=c.customer_id
);

SELECT
    c.customer_id,
    c.first_name
FROM customers c
LEFT JOIN orders o
ON c.customer_id=o.customer_id
WHERE o.customer_id IS NULL;

-- CUSTOMERS ABOVE AVERAGE SPENDING

WITH customer_spending AS(
    SELECT
        o.customer_id,
        SUM(o.quantity*p.price) AS total_spending
    FROM orders o
    JOIN products p
    ON o.product_id=p.product_id
    GROUP BY o.customer_id
)
SELECT *
FROM customer_spending
WHERE total_spending>(
    SELECT AVG(total_spending)
    FROM customer_spending
);

-- DEPARTMENT WITH HIGHEST AVERAGE SALARY

WITH department_salary AS(
    SELECT
        department,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department
)
SELECT *
FROM department_salary
WHERE average_salary=(
    SELECT MAX(average_salary)
    FROM department_salary
);

-- DEPARTMENT WITH MORE THAN 2 EMPLOYEES

WITH department_count AS(
    SELECT
        department,
        COUNT(*) AS employee_count
    FROM employees
    GROUP BY department
)
SELECT *
FROM department_count
WHERE employee_count>2;

-- TOP 3 EMPLOYEES PER DEPARTMENT

WITH ranked_employees AS(
    SELECT
        employee_name,
        department,
        salary,
        DENSE_RANK() OVER(
            PARTITION BY department
            ORDER BY salary DESC
        ) AS salary_rank
    FROM employees
)
SELECT *
FROM ranked_employees
WHERE salary_rank<=3;

-- THIRD HIGHEST SALARY

SELECT salary
FROM(
    SELECT
        salary,
        DENSE_RANK() OVER(
            ORDER BY salary DESC
        ) AS salary_rank
    FROM employees
) ranked
WHERE salary_rank=3;

-- EMPLOYEES WITH SAME SALARY

SELECT *
FROM employees
WHERE salary IN(
    SELECT salary
    FROM employees
    GROUP BY salary
    HAVING COUNT(*)>1
)
ORDER BY salary DESC;

-- DEPARTMENTS WITH SALARY ABOVE OVERALL AVERAGE

SELECT DISTINCT department
FROM employees
WHERE department IN(
    SELECT department
    FROM employees
    GROUP BY department
    HAVING AVG(salary)>(
        SELECT AVG(salary)
        FROM employees
    )
);