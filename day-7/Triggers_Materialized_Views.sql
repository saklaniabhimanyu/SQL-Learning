-- Triggers

CREATE TABLE employee_audit (
    audit_id SERIAL PRIMARY KEY,
    employee_id INT,
    old_salary DECIMAL(12,2),
    new_salary DECIMAL(12,2),
    action VARCHAR(20),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE employees
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP;

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

CREATE TRIGGER employee_updated_at
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

UPDATE employees
SET salary = salary + 1000
WHERE employee_id = 1;

-- OLD and NEW

CREATE OR REPLACE FUNCTION log_salary_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO employee_audit (employee_id, old_salary, new_salary, action)
    VALUES (OLD.employee_id, OLD.salary, NEW.salary, 'UPDATE');
    RETURN NEW;
END;
$$;

CREATE TRIGGER salary_change_audit
AFTER UPDATE OF salary ON employees
FOR EACH ROW
EXECUTE FUNCTION log_salary_change();

UPDATE employees
SET salary = salary + 2000
WHERE employee_id = 2;

SELECT * FROM employee_audit;

-- BEFORE INSERT

CREATE OR REPLACE FUNCTION validate_salary()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.salary < 0 THEN
        RAISE EXCEPTION 'Salary cannot be negative';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER validate_employee_salary
BEFORE INSERT OR UPDATE OF salary ON employees
FOR EACH ROW
EXECUTE FUNCTION validate_salary();

-- Statement-level trigger

CREATE TABLE employee_changes (
    change_id SERIAL PRIMARY KEY,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action VARCHAR(20)
);

CREATE OR REPLACE FUNCTION log_employee_statement()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO employee_changes (action) VALUES (TG_OP);
    RETURN NULL;
END;
$$;

CREATE TRIGGER employee_statement_audit
AFTER UPDATE ON employees
FOR EACH STATEMENT
EXECUTE FUNCTION log_employee_statement();

UPDATE employees
SET salary = salary + 500
WHERE department_id = 1;

SELECT * FROM employee_changes;

-- Drop trigger

DROP TRIGGER IF EXISTS employee_statement_audit ON employees;

-- Materialized Views

CREATE MATERIALIZED VIEW employee_salary_summary AS
SELECT
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS average_salary,
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary
FROM employees
GROUP BY department_id;

SELECT * FROM employee_salary_summary;

REFRESH MATERIALIZED VIEW employee_salary_summary;

CREATE UNIQUE INDEX employee_salary_summary_department_idx
ON employee_salary_summary(department_id);

REFRESH MATERIALIZED VIEW CONCURRENTLY employee_salary_summary;

-- Materialized view with joins

CREATE MATERIALIZED VIEW department_salary_summary AS
SELECT
    d.department_id,
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    COALESCE(AVG(e.salary), 0) AS average_salary
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;

SELECT * FROM department_salary_summary;

REFRESH MATERIALIZED VIEW department_salary_summary;

-- Drop materialized views

DROP MATERIALIZED VIEW IF EXISTS department_salary_summary;
DROP MATERIALIZED VIEW IF EXISTS employee_salary_summary;

-- Temporary Tables

CREATE TEMP TABLE temp_employees AS
SELECT * FROM employees;

SELECT * FROM temp_employees;

CREATE TEMP TABLE temp_salary_summary (
    department_id INT,
    employee_count INT,
    average_salary DECIMAL(12,2)
);

INSERT INTO temp_salary_summary
SELECT
    department_id,
    COUNT(*),
    ROUND(AVG(salary), 2)
FROM employees
GROUP BY department_id;

SELECT * FROM temp_salary_summary;

-- Temporary table with joins

CREATE TEMP TABLE temp_employee_details AS
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    e.salary
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id;

SELECT * FROM temp_employee_details;

-- ON COMMIT

CREATE TEMP TABLE temp_preserve (
    id INT
) ON COMMIT PRESERVE ROWS;

CREATE TEMP TABLE temp_delete (
    id INT
) ON COMMIT DELETE ROWS;

CREATE TEMP TABLE temp_drop (
    id INT
) ON COMMIT DROP;

INSERT INTO temp_preserve VALUES (1);
INSERT INTO temp_delete VALUES (1);
INSERT INTO temp_drop VALUES (1);

-- Temporary table indexes

CREATE INDEX temp_employee_salary_idx
ON temp_employee_details(salary);

SELECT *
FROM temp_employee_details
WHERE salary > 70000;

-- Drop temporary tables

DROP TABLE IF EXISTS temp_employees;
DROP TABLE IF EXISTS temp_salary_summary;
DROP TABLE IF EXISTS temp_employee_details;
DROP TABLE IF EXISTS temp_preserve;
DROP TABLE IF EXISTS temp_delete;
DROP TABLE IF EXISTS temp_drop;

-- Final trigger data

SELECT * FROM employee_audit;
SELECT * FROM employee_changes;
