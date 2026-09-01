-- CASE

SELECT
    employee_name,
    salary,
    CASE
        WHEN salary>=90000 THEN 'High'
        WHEN salary>=70000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_category
FROM employees;

SELECT
    employee_name,
    salary,
    CASE
        WHEN salary>=90000 THEN 'A'
        WHEN salary>=80000 THEN 'B'
        WHEN salary>=70000 THEN 'C'
        ELSE 'D'
    END AS salary_grade
FROM employees;

SELECT
    department,
    COUNT(CASE WHEN salary>=80000 THEN 1 END) AS high_salary,
    COUNT(CASE WHEN salary<80000 THEN 1 END) AS low_salary
FROM employees
GROUP BY department;

-- COALESCE

SELECT
    employee_name,
    COALESCE(department,'Unknown') AS department
FROM employees;

SELECT
    customer_id,
    COALESCE(balance,0) AS balance
FROM customers;

-- NULLIF

SELECT NULLIF(10,10);
SELECT NULLIF(10,5);

-- CAST

SELECT
    salary,
    CAST(salary AS INTEGER) AS salary_integer
FROM employees;

SELECT salary::INTEGER
FROM employees;

-- STRING FUNCTIONS

SELECT UPPER(employee_name)
FROM employees;

SELECT LOWER(employee_name)
FROM employees;

SELECT LENGTH(employee_name)
FROM employees;

SELECT TRIM(employee_name)
FROM employees;

SELECT CONCAT(employee_name,' - ',department)
FROM employees;

SELECT employee_name||' - '||department
FROM employees;

SELECT SUBSTRING(employee_name FROM 1 FOR 3)
FROM employees;

SELECT REPLACE(employee_name,'a','A')
FROM employees;

-- DATE & TIME FUNCTIONS

SELECT CURRENT_DATE;

SELECT CURRENT_TIMESTAMP;

SELECT
    employee_name,
    EXTRACT(YEAR FROM joining_date) AS joining_year
FROM employees;

SELECT
    employee_name,
    CURRENT_DATE-joining_date AS days_since_joining
FROM employees;

SELECT
    employee_name,
    AGE(CURRENT_DATE,joining_date) AS experience
FROM employees;

SELECT
    DATE_TRUNC('month',joining_date) AS joining_month
FROM employees;

-- MATH FUNCTIONS

SELECT ROUND(125.567,2);

SELECT CEIL(125.2);

SELECT FLOOR(125.8);

SELECT ABS(-100);

SELECT POWER(2,3);

SELECT MOD(10,3);

SELECT
    employee_name,
    ROUND(salary/12,2) AS monthly_salary
FROM employees;

-- CONDITIONAL AGGREGATION

SELECT
    department,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN salary>=80000 THEN 1 END) AS high_salary,
    COUNT(CASE WHEN salary<80000 THEN 1 END) AS low_salary,
    SUM(CASE WHEN salary>=80000 THEN salary ELSE 0 END) AS high_salary_total
FROM employees
GROUP BY department;

-- FILTER

SELECT
    department,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER(WHERE salary>=80000) AS high_salary,
    COUNT(*) FILTER(WHERE salary<80000) AS low_salary,
    AVG(salary) FILTER(WHERE salary>=80000) AS high_salary_average,
    SUM(salary) FILTER(WHERE salary>=80000) AS high_salary_total
FROM employees
GROUP BY department;

-- UNION

SELECT department
FROM employees
WHERE salary>85000
UNION
SELECT department
FROM employees
WHERE salary<70000;

-- UNION ALL

SELECT department
FROM employees
WHERE salary>85000
UNION ALL
SELECT department
FROM employees
WHERE salary<70000;

-- INTERSECT

SELECT department
FROM employees
WHERE salary>70000
INTERSECT
SELECT department
FROM employees
WHERE salary<90000;

-- EXCEPT

SELECT department
FROM employees
WHERE salary>70000
EXCEPT
SELECT department
FROM employees
WHERE salary>90000;

-- DISTINCT ON

SELECT DISTINCT ON(department)
    department,
    employee_name,
    salary
FROM employees
ORDER BY department,salary DESC;

SELECT DISTINCT ON(department)
    department,
    employee_name,
    joining_date
FROM employees
ORDER BY department,joining_date;

-- INSERT RETURNING

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

-- UPDATE RETURNING

UPDATE employees
SET salary=salary*1.05
WHERE department='IT'
RETURNING employee_id,employee_name,salary;

-- DELETE RETURNING

DELETE FROM employees
WHERE salary<65000
RETURNING *;

-- ON CONFLICT

INSERT INTO customers(
    first_name,
    last_name,
    email
)
VALUES(
    'Aarav',
    'Sharma',
    'aarav.sharma@gmail.com'
)
ON CONFLICT(email)
DO NOTHING;

-- UPSERT

INSERT INTO customers(
    first_name,
    last_name,
    email
)
VALUES(
    'Aarav',
    'Sharma',
    'aarav.sharma@gmail.com'
)
ON CONFLICT(email)
DO UPDATE
SET
    first_name=EXCLUDED.first_name,
    last_name=EXCLUDED.last_name;

-- FUNCTION

CREATE OR REPLACE FUNCTION add_numbers(a INT,b INT)
RETURNS INT
LANGUAGE SQL
AS $$
    SELECT a+b;
$$;

SELECT add_numbers(10,20);

-- FUNCTION WITH PARAMETERS

CREATE OR REPLACE FUNCTION multiply_numbers(a INT,b INT)
RETURNS INT
LANGUAGE SQL
AS $$
    SELECT a*b;
$$;

SELECT multiply_numbers(10,5);

-- FUNCTION WITH TABLE DATA

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

SELECT get_employee_salary(1);

-- FUNCTION WITH IF

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

SELECT
    employee_name,
    salary,
    salary_category(salary)
FROM employees;

-- FUNCTION RETURNING TABLE

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

SELECT *
FROM get_department_employees('IT');

-- FUNCTION WITH AGGREGATION

CREATE OR REPLACE FUNCTION get_department_average(dept VARCHAR)
RETURNS DECIMAL
LANGUAGE SQL
AS $$
    SELECT AVG(salary)
    FROM employees
    WHERE department=dept;
$$;

SELECT get_department_average('IT');

-- FUNCTION WITH DEFAULT PARAMETER

CREATE OR REPLACE FUNCTION increase_salary(
    emp_id INT,
    amount DECIMAL DEFAULT 1000
)
RETURNS DECIMAL
LANGUAGE SQL
AS $$
    UPDATE employees
    SET salary=salary+amount
    WHERE employee_id=emp_id
    RETURNING salary;
$$;

SELECT increase_salary(1);
SELECT increase_salary(1,5000);

-- FUNCTION DROP

DROP FUNCTION IF EXISTS add_numbers(INT,INT);

-- PROCEDURE

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

CALL update_employee_salary(1,5000);

-- PROCEDURE WITH IF

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

CALL update_salary(1,5000);

-- PROCEDURE WITH MULTIPLE OPERATIONS

CREATE OR REPLACE PROCEDURE update_employee(
    emp_id INT,
    new_department VARCHAR,
    salary_increase DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE employees
    SET department=new_department
    WHERE employee_id=emp_id;

    UPDATE employees
    SET salary=salary+salary_increase
    WHERE employee_id=emp_id;
END;
$$;

CALL update_employee(1,'Data Science',5000);

-- PROCEDURE DROP

DROP PROCEDURE IF EXISTS update_salary(INT,DECIMAL);

-- FUNCTION WITH CASE

CREATE OR REPLACE FUNCTION get_salary_grade(emp_salary DECIMAL)
RETURNS CHAR
LANGUAGE SQL
AS $$
    SELECT
        CASE
            WHEN emp_salary>=90000 THEN 'A'
            WHEN emp_salary>=80000 THEN 'B'
            WHEN emp_salary>=70000 THEN 'C'
            ELSE 'D'
        END;
$$;

SELECT
    employee_name,
    salary,
    get_salary_grade(salary)
FROM employees;

-- FUNCTION WITH COALESCE

CREATE OR REPLACE FUNCTION get_customer_balance(
    customer INT
)
RETURNS DECIMAL
LANGUAGE SQL
AS $$
    SELECT COALESCE(balance,0)
    FROM customers
    WHERE customer_id=customer;
$$;

SELECT get_customer_balance(1);

-- PRACTICE

SELECT
    employee_name,
    salary,
    CASE
        WHEN salary>=90000 THEN 'High'
        WHEN salary>=75000 THEN 'Medium'
        ELSE 'Low'
    END AS category
FROM employees;

SELECT
    department,
    COUNT(*) FILTER(WHERE salary>=80000) AS high_salary_count
FROM employees
GROUP BY department;

SELECT DISTINCT ON(department)
    department,
    employee_name,
    salary
FROM employees
ORDER BY department,salary DESC;

SELECT department
FROM employees
WHERE salary>=80000
UNION
SELECT department
FROM employees
WHERE salary<70000;

INSERT INTO customers(first_name,last_name,email)
VALUES('Test','User','test@gmail.com')
ON CONFLICT(email)
DO UPDATE SET first_name=EXCLUDED.first_name
RETURNING *;

SELECT get_department_average('IT');

CALL update_employee_salary(1,2000);
