# Day 6 — Transactions & ACID

Day 6 covers SQL transactions, transaction control, ACID properties, isolation levels, and concurrency problems in relational databases.

Database: PostgreSQL

---
Topics Covered

- Transactions
- Transaction Lifecycle
- "BEGIN"
- "COMMIT"
- "ROLLBACK"
- "SAVEPOINT"
- "ROLLBACK TO SAVEPOINT"
- "RELEASE SAVEPOINT"
- ACID Properties
  - Atomicity
  - Consistency
  - Isolation
  - Durability
- Transaction Isolation
- "READ COMMITTED"
- "REPEATABLE READ"
- "SERIALIZABLE"
- Concurrency
- Dirty Read
- Non-Repeatable Read
- Phantom Read
- Transaction Conflicts
- Locking Basics

---

1. What is a Transaction?

A transaction is a sequence of one or more SQL operations treated as a single unit of work.

Either all required operations succeed, or the transaction can be rolled back.

Example:

BEGIN;

UPDATE accounts
SET balance = balance - 1000
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 1000
WHERE account_id = 2;

COMMIT;

Both updates belong to the same transaction.

---

2. Transaction Lifecycle

A typical transaction follows:

BEGIN
  ↓
SQL Operations
  ↓
COMMIT

If something goes wrong:

BEGIN
  ↓
SQL Operations
  ↓
ROLLBACK

With a savepoint:

BEGIN
  ↓
SQL Operations
  ↓
SAVEPOINT
  ↓
More SQL
  ↓
ROLLBACK TO SAVEPOINT
  ↓
COMMIT

---

3. BEGIN

"BEGIN" starts a transaction.

Syntax

BEGIN;

Example:

BEGIN;

UPDATE accounts
SET balance = balance - 500
WHERE account_id = 1;

The changes are not permanently committed yet.

---

4. COMMIT

"COMMIT" permanently saves the changes made during the transaction.

Syntax

COMMIT;

Example:

BEGIN;

UPDATE accounts
SET balance = balance - 500
WHERE account_id = 1;

COMMIT;

---

5. ROLLBACK

"ROLLBACK" cancels the changes made during the current transaction.

Syntax

ROLLBACK;

Example:

BEGIN;

UPDATE accounts
SET balance = balance - 500
WHERE account_id = 1;

ROLLBACK;

The update is undone.

---

6. SAVEPOINT

A SAVEPOINT creates a point inside a transaction to which you can partially roll back.

Syntax

SAVEPOINT savepoint_name;

Example:

BEGIN;

UPDATE accounts
SET balance = balance - 500
WHERE account_id = 1;

SAVEPOINT transfer_point;

UPDATE accounts
SET balance = balance + 500
WHERE account_id = 2;

---

7. ROLLBACK TO SAVEPOINT

Rolls back only the operations performed after the specified savepoint.

Syntax

ROLLBACK TO SAVEPOINT savepoint_name;

Example:

BEGIN;

UPDATE accounts
SET balance = balance - 500
WHERE account_id = 1;

SAVEPOINT transfer_point;

UPDATE accounts
SET balance = balance + 500
WHERE account_id = 2;

ROLLBACK TO SAVEPOINT transfer_point;

COMMIT;

The operations before the savepoint remain.

---

8. RELEASE SAVEPOINT

Removes a savepoint that is no longer needed.

Syntax

RELEASE SAVEPOINT savepoint_name;

Example:

BEGIN;

UPDATE accounts
SET balance = balance - 500
WHERE account_id = 1;

SAVEPOINT transfer_point;

UPDATE accounts
SET balance = balance + 500
WHERE account_id = 2;

RELEASE SAVEPOINT transfer_point;

COMMIT;

---

9. Multiple Savepoints

A transaction can contain multiple savepoints.

BEGIN;

UPDATE accounts
SET balance = balance - 100
WHERE account_id = 1;

SAVEPOINT point1;

UPDATE accounts
SET balance = balance - 200
WHERE account_id = 1;

SAVEPOINT point2;

UPDATE accounts
SET balance = balance - 300
WHERE account_id = 1;

ROLLBACK TO SAVEPOINT point2;

COMMIT;

---

10. ACID Properties

ACID describes the four major properties that make transactions reliable.

A → Atomicity
C → Consistency
I → Isolation
D → Durability

---

11. Atomicity

Atomicity means a transaction is treated as one indivisible unit.

Either all required operations succeed or the transaction is rolled back.

Example:

Transfer ₹1000

Account A → -₹1000
Account B → +₹1000

Both operations should succeed together.

If one fails, the transaction can be rolled back.

Both succeed → COMMIT
Failure      → ROLLBACK

---

12. Consistency

Consistency ensures that a transaction moves the database from one valid state to another valid state.

Example:

Account A = ₹10,000
Account B = ₹5,000

Total = ₹15,000

After transferring ₹2,000:

Account A = ₹8,000
Account B = ₹7,000

Total = ₹15,000

Database rules and constraints should remain valid.

---

13. Isolation

Isolation controls how transactions interact with each other when multiple transactions execute concurrently.

Ideally, one transaction should not see inappropriate intermediate changes from another transaction.

Isolation levels determine the amount of visibility between concurrent transactions.

---

14. Durability

Durability means that once a transaction is committed, its changes should survive system failures.

COMMIT
  ↓
Changes become durable

Database systems use mechanisms such as transaction logs and recovery processes to provide durability.

---

15. ACID Summary

Property| Meaning
Atomicity| All or nothing
Consistency| Database remains valid
Isolation| Concurrent transactions are controlled
Durability| Committed changes persist

---

16. Transaction Isolation

PostgreSQL supports these isolation levels:

READ COMMITTED
REPEATABLE READ
SERIALIZABLE

PostgreSQL's default isolation level is:

READ COMMITTED

---

17. SET TRANSACTION

Syntax

SET TRANSACTION ISOLATION LEVEL isolation_level;

Example:

BEGIN;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT *
FROM accounts;

COMMIT;

---

18. READ COMMITTED

"READ COMMITTED" prevents a transaction from reading data that another transaction has not committed.

A query sees data committed before that query begins.

Example:

BEGIN;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT *
FROM accounts;

COMMIT;

This is PostgreSQL's default isolation level.

---

19. REPEATABLE READ

"REPEATABLE READ" provides a consistent view of data within the transaction.

Example:

BEGIN;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT *
FROM accounts;

SELECT *
FROM accounts;

COMMIT;

Repeated reads within the transaction use the transaction's consistent snapshot.

---

20. SERIALIZABLE

"SERIALIZABLE" provides the strongest standard isolation level.

It makes concurrent transactions behave as though they were executed serially.

Example:

BEGIN;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT *
FROM accounts;

COMMIT;

A transaction may need to be retried if PostgreSQL detects a serialization conflict.

---

21. Isolation Level Comparison

Isolation Level| Dirty Read| Non-Repeatable Read| Phantom Read
READ COMMITTED| No| Possible| Possible
REPEATABLE READ| No| No| No*
SERIALIZABLE| No| No| No

"*" PostgreSQL's implementation of "REPEATABLE READ" is stronger than the minimum SQL-standard requirement and uses snapshot isolation.

---

22. Dirty Read

A dirty read occurs when one transaction reads data written by another transaction before that transaction commits.

Example concept:

Transaction A
UPDATE balance = 5000
       ↓
Transaction B reads 5000
       ↓
Transaction A ROLLBACK

Transaction B read a value that was never committed.

PostgreSQL does not allow dirty reads under its supported isolation levels.

---

23. Non-Repeatable Read

A non-repeatable read occurs when the same row is read twice in one transaction and another committed transaction changes it between the two reads.

Transaction A → Read balance = 5000

Transaction B → Update balance = 7000
Transaction B → COMMIT

Transaction A → Read balance = 7000

The same query can observe a different value.

---

24. Phantom Read

A phantom read occurs when repeated execution of a query returns a different set of rows because another transaction inserted or deleted matching rows.

Example:

Transaction A
SELECT * FROM employees
WHERE salary > 80000;

→ 3 rows

Transaction B
INSERT employee with salary 90000
COMMIT

Transaction A
SELECT * FROM employees
WHERE salary > 80000;

→ 4 rows

The newly appearing row is a phantom.

---

25. Transaction Conflicts

Concurrent transactions can interact in ways that require database control.

Common issues include:

Dirty Reads
Non-Repeatable Reads
Phantom Reads
Lost Updates
Serialization Conflicts

---

26. Lost Update

A lost update can occur when two transactions read and modify the same data and one update overwrites the other.

Concept:

Transaction A → Read balance = 1000
Transaction B → Read balance = 1000

Transaction A → Write 900
Transaction B → Write 800

A's update may be lost.

Concurrency control and appropriate locking/isolation can prevent such problems.

---

27. Row-Level Locking

Rows can be locked during a transaction.

"FOR UPDATE"

BEGIN;

SELECT *
FROM accounts
WHERE account_id = 1
FOR UPDATE;

UPDATE accounts
SET balance = balance - 500
WHERE account_id = 1;

COMMIT;

The selected row is locked for update by the transaction.

---

28. "FOR SHARE"

A shared lock can be requested using:

SELECT *
FROM accounts
WHERE account_id = 1
FOR SHARE;

This is useful when a transaction needs to protect rows from conflicting modifications while it operates.

---

29. Transaction Example

Bank transfer:

BEGIN;

UPDATE accounts
SET balance = balance - 1000
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 1000
WHERE account_id = 2;

COMMIT;

If an error occurs:

BEGIN;

UPDATE accounts
SET balance = balance - 1000
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 1000
WHERE account_id = 2;

ROLLBACK;

---

30. Transaction With Savepoint

BEGIN;

UPDATE accounts
SET balance = balance - 1000
WHERE account_id = 1;

SAVEPOINT transfer;

UPDATE accounts
SET balance = balance + 1000
WHERE account_id = 2;

ROLLBACK TO SAVEPOINT transfer;

COMMIT;

---

31. Transaction State

A simplified transaction lifecycle:

BEGIN
  ↓
ACTIVE
  ↓
SQL Operations
  ↓
COMMIT
  ↓
COMMITTED

Or:

BEGIN
  ↓
ACTIVE
  ↓
ERROR
  ↓
ROLLBACK
  ↓
ABORTED

---

32. Autocommit

Many SQL clients operate with autocommit enabled by default.

Without explicitly starting a transaction:

UPDATE accounts
SET balance = balance - 500
WHERE account_id = 1;

the statement may be committed automatically by the client/session.

Explicit transaction:

BEGIN;

UPDATE accounts
SET balance = balance - 500
WHERE account_id = 1;

COMMIT;

---

33. Transaction Commands Quick Revision

BEGIN
→ Start transaction

COMMIT
→ Save transaction changes

ROLLBACK
→ Undo transaction changes

SAVEPOINT
→ Create rollback point

ROLLBACK TO SAVEPOINT
→ Undo changes after savepoint

RELEASE SAVEPOINT
→ Remove savepoint

SET TRANSACTION
→ Configure transaction properties

---

34. ACID Quick Revision

ATOMICITY
→ All or nothing

CONSISTENCY
→ Valid state → Valid state

ISOLATION
→ Control concurrent transactions

DURABILITY
→ Committed data persists

---

35. Isolation Level Quick Revision

READ COMMITTED
→ Default PostgreSQL isolation level

REPEATABLE READ
→ Consistent snapshot within transaction

SERIALIZABLE
→ Strongest isolation
→ Transactions behave as if executed serially

---

36. Concurrency Quick Revision

DIRTY READ
→ Reading uncommitted data

NON-REPEATABLE READ
→ Same row gives different values

PHANTOM READ
→ Same query returns different row sets

LOST UPDATE
→ One concurrent update overwrites another

SERIALIZATION CONFLICT
→ Concurrent transactions cannot be safely serialized

---
