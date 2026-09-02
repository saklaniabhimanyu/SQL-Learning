-- Transactions

CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    account_holder VARCHAR(100) NOT NULL,
    balance DECIMAL(12,2) NOT NULL DEFAULT 0.00
);

INSERT INTO accounts (account_holder, balance) VALUES
('Abhimanyu', 50000.00),
('Rahul', 30000.00),
('Priya', 45000.00);

SELECT * FROM accounts;

-- BEGIN / COMMIT

BEGIN;

UPDATE accounts
SET balance = balance - 5000
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 5000
WHERE account_id = 2;

COMMIT;

-- ROLLBACK

BEGIN;

UPDATE accounts
SET balance = balance - 10000
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 10000
WHERE account_id = 3;

ROLLBACK;

-- SAVEPOINT

BEGIN;

UPDATE accounts
SET balance = balance - 5000
WHERE account_id = 1;

SAVEPOINT transfer_point;

UPDATE accounts
SET balance = balance + 5000
WHERE account_id = 2;

ROLLBACK TO SAVEPOINT transfer_point;

UPDATE accounts
SET balance = balance + 5000
WHERE account_id = 3;

COMMIT;

-- RELEASE SAVEPOINT

BEGIN;

UPDATE accounts
SET balance = balance - 2000
WHERE account_id = 1;

SAVEPOINT balance_update;

UPDATE accounts
SET balance = balance + 2000
WHERE account_id = 2;

RELEASE SAVEPOINT balance_update;

COMMIT;

-- Transaction isolation

SHOW transaction_isolation;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN;
SELECT * FROM accounts;
COMMIT;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

BEGIN;
SELECT * FROM accounts;
COMMIT;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN;
SELECT * FROM accounts;
COMMIT;

-- Row-level locking

BEGIN;

SELECT *
FROM accounts
WHERE account_id = 1
FOR UPDATE;

UPDATE accounts
SET balance = balance - 1000
WHERE account_id = 1;

COMMIT;

-- FOR SHARE

BEGIN;

SELECT *
FROM accounts
WHERE account_id = 1
FOR SHARE;

COMMIT;

-- Locking multiple rows

BEGIN;

SELECT *
FROM accounts
WHERE account_id IN (1, 2)
FOR UPDATE;

UPDATE accounts
SET balance = balance - 1000
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 1000
WHERE account_id = 2;

COMMIT;

-- ACID consistency with constraints

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    from_account INT REFERENCES accounts(account_id),
    to_account INT REFERENCES accounts(account_id),
    amount DECIMAL(12,2) CHECK (amount > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

BEGIN;

INSERT INTO transactions (from_account, to_account, amount)
VALUES (1, 2, 2500);

UPDATE accounts
SET balance = balance - 2500
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 2500
WHERE account_id = 2;

COMMIT;

-- Transaction failure and rollback

BEGIN;

UPDATE accounts
SET balance = balance - 5000
WHERE account_id = 1;

INSERT INTO transactions (from_account, to_account, amount)
VALUES (1, 2, -100);

ROLLBACK;

-- Nested savepoints

BEGIN;

UPDATE accounts
SET balance = balance - 1000
WHERE account_id = 1;

SAVEPOINT first_update;

UPDATE accounts
SET balance = balance + 1000
WHERE account_id = 2;

SAVEPOINT second_update;

UPDATE accounts
SET balance = balance + 500
WHERE account_id = 3;

ROLLBACK TO SAVEPOINT second_update;

COMMIT;

-- Transaction status

SELECT txid_current();

-- Deadlock prevention by consistent lock ordering

BEGIN;

SELECT *
FROM accounts
WHERE account_id = 1
FOR UPDATE;

SELECT *
FROM accounts
WHERE account_id = 2
FOR UPDATE;

COMMIT;

-- Final data

SELECT * FROM accounts;
SELECT * FROM transactions;
