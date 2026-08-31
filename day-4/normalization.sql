-- DATA REDUNDANCY

CREATE TABLE student_course_raw(
    student_id INT,
    student_name VARCHAR(100),
    course_id INT,
    course_name VARCHAR(100),
    instructor_name VARCHAR(100),
    instructor_email VARCHAR(255)
);

INSERT INTO student_course_raw
VALUES
(1,'Aarav',101,'DBMS','Rahul','rahul@gmail.com'),
(2,'Priya',101,'DBMS','Rahul','rahul@gmail.com'),
(3,'Rohan',102,'AI','Sneha','sneha@gmail.com'),
(4,'Kavya',102,'AI','Sneha','sneha@gmail.com');

SELECT * FROM student_course_raw;

-- 1NF

CREATE TABLE student_phones(
    student_id INT,
    student_name VARCHAR(100),
    phone VARCHAR(15)
);

INSERT INTO student_phones
VALUES
(1,'Aarav','9876543210'),
(1,'Aarav','8765432109'),
(2,'Priya','9876501234');

SELECT * FROM student_phones;

-- 2NF

CREATE TABLE enrollment_2nf(
    student_id INT,
    course_id INT,
    grade VARCHAR(2),
    PRIMARY KEY(student_id,course_id)
);

CREATE TABLE students_2nf(
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100)
);

CREATE TABLE courses_2nf(
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100)
);

INSERT INTO students_2nf
VALUES
(1,'Aarav'),
(2,'Priya'),
(3,'Rohan');

INSERT INTO courses_2nf
VALUES
(101,'DBMS'),
(102,'AI');

INSERT INTO enrollment_2nf
VALUES
(1,101,'A'),
(2,101,'B'),
(3,102,'A');

SELECT * FROM students_2nf;
SELECT * FROM courses_2nf;
SELECT * FROM enrollment_2nf;

-- FOREIGN KEY

ALTER TABLE enrollment_2nf
ADD CONSTRAINT fk_enrollment_student
FOREIGN KEY(student_id)
REFERENCES students_2nf(student_id);

ALTER TABLE enrollment_2nf
ADD CONSTRAINT fk_enrollment_course
FOREIGN KEY(course_id)
REFERENCES courses_2nf(course_id);

-- 3NF

CREATE TABLE departments_3nf(
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

CREATE TABLE employees_3nf(
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department_id INT,
    FOREIGN KEY(department_id)
        REFERENCES departments_3nf(department_id)
);

INSERT INTO departments_3nf
VALUES
(10,'IT'),
(20,'HR'),
(30,'Sales');

INSERT INTO employees_3nf
VALUES
(1,'Aarav',10),
(2,'Priya',10),
(3,'Rahul',20),
(4,'Sneha',30);

SELECT * FROM departments_3nf;
SELECT * FROM employees_3nf;

-- ONE TO ONE

CREATE TABLE persons(
    person_id INT PRIMARY KEY,
    person_name VARCHAR(100) NOT NULL
);

CREATE TABLE passports(
    passport_id INT PRIMARY KEY,
    person_id INT UNIQUE,
    passport_number VARCHAR(50) UNIQUE NOT NULL,
    FOREIGN KEY(person_id)
        REFERENCES persons(person_id)
);

INSERT INTO persons
VALUES
(1,'Aarav'),
(2,'Priya');

INSERT INTO passports
VALUES
(101,1,'P123456'),
(102,2,'P654321');

SELECT *
FROM persons p
JOIN passports pp
ON p.person_id=pp.person_id;

-- ONE TO MANY

CREATE TABLE customers_1n(
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);

CREATE TABLE orders_1n(
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE,
    FOREIGN KEY(customer_id)
        REFERENCES customers_1n(customer_id)
);

INSERT INTO customers_1n
VALUES
(1,'Aarav'),
(2,'Priya');

INSERT INTO orders_1n
VALUES
(101,1,'2026-01-10'),
(102,1,'2026-01-15'),
(103,2,'2026-02-05');

SELECT *
FROM customers_1n c
JOIN orders_1n o
ON c.customer_id=o.customer_id;

-- MANY TO MANY

CREATE TABLE students_mn(
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL
);

CREATE TABLE courses_mn(
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL
);

CREATE TABLE enrollments_mn(
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    PRIMARY KEY(student_id,course_id),
    FOREIGN KEY(student_id)
        REFERENCES students_mn(student_id),
    FOREIGN KEY(course_id)
        REFERENCES courses_mn(course_id)
);

INSERT INTO students_mn
VALUES
(1,'Aarav'),
(2,'Priya'),
(3,'Rohan');

INSERT INTO courses_mn
VALUES
(101,'DBMS'),
(102,'AI'),
(103,'Machine Learning');

INSERT INTO enrollments_mn
VALUES
(1,101,'2026-01-10'),
(1,102,'2026-01-11'),
(2,101,'2026-01-12'),
(2,103,'2026-01-13'),
(3,102,'2026-01-14'),
(3,103,'2026-01-15');

SELECT
    s.student_name,
    c.course_name,
    e.enrollment_date
FROM students_mn s
JOIN enrollments_mn e
ON s.student_id=e.student_id
JOIN courses_mn c
ON e.course_id=c.course_id;

-- SUPER KEY

CREATE TABLE super_key_demo(
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    email VARCHAR(255) UNIQUE
);

-- CANDIDATE KEY

SELECT student_id
FROM super_key_demo;

SELECT email
FROM super_key_demo;

-- COMPOSITE KEY

CREATE TABLE course_registration(
    student_id INT,
    course_id INT,
    registration_date DATE,
    PRIMARY KEY(student_id,course_id)
);

-- FUNCTIONAL DEPENDENCY

CREATE TABLE functional_dependency(
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    email VARCHAR(255) UNIQUE
);

-- PARTIAL DEPENDENCY

CREATE TABLE partial_dependency(
    student_id INT,
    course_id INT,
    student_name VARCHAR(100),
    course_name VARCHAR(100),
    grade VARCHAR(2),
    PRIMARY KEY(student_id,course_id)
);

-- TRANSITIVE DEPENDENCY

CREATE TABLE transitive_dependency(
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department_id INT,
    department_name VARCHAR(100)
);

-- NORMALIZED VERSION

CREATE TABLE departments(
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE employees(
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department_id INT,
    FOREIGN KEY(department_id)
        REFERENCES departments(department_id)
);

-- BCNF EXAMPLE

CREATE TABLE instructors(
    instructor_id INT PRIMARY KEY,
    instructor_name VARCHAR(100) NOT NULL
);

CREATE TABLE subjects(
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL
);

CREATE TABLE instructor_subject(
    instructor_id INT,
    subject_id INT,
    PRIMARY KEY(instructor_id,subject_id),
    FOREIGN KEY(instructor_id)
        REFERENCES instructors(instructor_id),
    FOREIGN KEY(subject_id)
        REFERENCES subjects(subject_id)
);

-- NORMALIZED E-COMMERCE DATABASE

CREATE TABLE customers_final(
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE categories_final(
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE products_final(
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY(category_id)
        REFERENCES categories_final(category_id)
);

CREATE TABLE orders_final(
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY(customer_id)
        REFERENCES customers_final(customer_id)
);

CREATE TABLE order_items_final(
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    PRIMARY KEY(order_id,product_id),
    FOREIGN KEY(order_id)
        REFERENCES orders_final(order_id),
    FOREIGN KEY(product_id)
        REFERENCES products_final(product_id)
);

INSERT INTO customers_final(customer_name,email)
VALUES
('Aarav','aarav@gmail.com'),
('Priya','priya@gmail.com'),
('Rohan','rohan@gmail.com');

INSERT INTO categories_final(category_name)
VALUES
('Electronics'),
('Books'),
('Accessories');

INSERT INTO products_final(product_name,category_id,price)
VALUES
('Laptop',1,75000),
('SQL Book',2,1200),
('Keyboard',3,2500),
('Mouse',3,1000);

INSERT INTO orders_final(customer_id,order_date)
VALUES
(1,'2026-08-01'),
(1,'2026-08-05'),
(2,'2026-08-10');

INSERT INTO order_items_final(order_id,product_id,quantity)
VALUES
(1,1,1),
(1,3,1),
(2,2,2),
(3,4,1);

SELECT
    c.customer_name,
    o.order_id,
    o.order_date,
    p.product_name,
    oi.quantity,
    p.price,
    oi.quantity*p.price AS total
FROM customers_final c
JOIN orders_final o
ON c.customer_id=o.customer_id
JOIN order_items_final oi
ON o.order_id=oi.order_id
JOIN products_final p
ON oi.product_id=p.product_id;

-- NORMALIZATION CHECK

SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema='public'
ORDER BY table_name,ordinal_position;
