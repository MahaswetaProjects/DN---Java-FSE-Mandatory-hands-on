-- ============================================================
-- STEP 0: CREATE TABLES
-- ============================================================

CREATE TABLE Customers (
    CustomerID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    DOB DATE,
    Balance NUMBER,
    LastModified DATE
);

CREATE TABLE Accounts (
    AccountID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    AccountType VARCHAR2(20),
    Balance NUMBER,
    LastModified DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Transactions (
    TransactionID NUMBER PRIMARY KEY,
    AccountID NUMBER,
    TransactionDate DATE,
    Amount NUMBER,
    TransactionType VARCHAR2(10),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE Loans (
    LoanID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    LoanAmount NUMBER,
    InterestRate NUMBER,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Employees (
    EmployeeID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Position VARCHAR2(50),
    Salary NUMBER,
    Department VARCHAR2(50),
    HireDate DATE
);

-- AuditLog table for trigger exercise
CREATE TABLE AuditLog (
    LogID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TransactionID NUMBER,
    AccountID NUMBER,
    Amount NUMBER,
    TransactionType VARCHAR2(10),
    LogDate DATE
);

-- IsVIP column for control structure exercise
ALTER TABLE Customers ADD IsVIP VARCHAR2(5) DEFAULT 'FALSE';

-- ============================================================
-- STEP 1: INSERT SAMPLE DATA
-- ============================================================

-- Customer 1 is above 60 (born 1955) to test age discount
-- Customer 1 balance > 10000 to test VIP flag
INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
VALUES (1, 'John Doe', TO_DATE('1955-05-15','YYYY-MM-DD'), 12000, SYSDATE);

INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
VALUES (2, 'Jane Smith', TO_DATE('1990-07-20','YYYY-MM-DD'), 8000, SYSDATE);

INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
VALUES (1, 1, 'Savings', 12000, SYSDATE);

INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
VALUES (2, 2, 'Savings', 8000, SYSDATE);

INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
VALUES (1, 1, SYSDATE, 200, 'Deposit');

INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
VALUES (2, 2, SYSDATE, 300, 'Withdrawal');

-- Loan EndDate within 30 days to test reminder scenario
INSERT INTO Loans (LoanID, CustomerID, LoanAmount, InterestRate, StartDate, EndDate)
VALUES (1, 1, 5000, 5, SYSDATE, SYSDATE + 10);

INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
VALUES (1, 'Alice Johnson', 'Manager', 70000, 'HR', TO_DATE('2015-06-15','YYYY-MM-DD'));

INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
VALUES (2, 'Bob Brown', 'Developer', 60000, 'IT', TO_DATE('2017-03-20','YYYY-MM-DD'));

COMMIT;

-- ============================================================
-- EXERCISE 1: CONTROL STRUCTURES
-- ============================================================

-- Scenario 1: Apply 1% discount on loan interest for customers above 60
BEGIN
    FOR c IN (SELECT CustomerID, DOB FROM Customers) LOOP
        IF TRUNC(MONTHS_BETWEEN(SYSDATE, c.DOB) / 12) > 60 THEN
            UPDATE Loans
            SET InterestRate = InterestRate - 1
            WHERE CustomerID = c.CustomerID;
            DBMS_OUTPUT.PUT_LINE('Discount applied for CustomerID: ' || c.CustomerID);
        END IF;
    END LOOP;
    COMMIT;
END;
/

-- Scenario 2: Set IsVIP = TRUE for customers with balance > $10,000
BEGIN
    FOR c IN (SELECT CustomerID, Balance FROM Customers) LOOP
        IF c.Balance > 10000 THEN
            UPDATE Customers SET IsVIP = 'TRUE' WHERE CustomerID = c.CustomerID;
            DBMS_OUTPUT.PUT_LINE('CustomerID ' || c.CustomerID || ' marked as VIP');
        END IF;
    END LOOP;
    COMMIT;
END;
/

-- Scenario 3: Print reminders for loans due within next 30 days
BEGIN
    FOR l IN (
        SELECT l.LoanID, c.Name, l.EndDate
        FROM Loans l
        JOIN Customers c ON l.CustomerID = c.CustomerID
        WHERE l.EndDate BETWEEN SYSDATE AND SYSDATE + 30
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Reminder: ' || l.Name || ' loan due on ' || TO_CHAR(l.EndDate,'YYYY-MM-DD'));
    END LOOP;
END;
/

-- ============================================================
-- EXERCISE 2: ERROR HANDLING
-- ============================================================

-- Scenario 1: SafeTransferFunds - rolls back on insufficient funds or any error
CREATE OR REPLACE PROCEDURE SafeTransferFunds(
    p_from_acc NUMBER,
    p_to_acc   NUMBER,
    p_amount   NUMBER
) AS
    v_balance NUMBER;
BEGIN
    SELECT Balance INTO v_balance FROM Accounts WHERE AccountID = p_from_acc;

    IF v_balance < p_amount THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient funds in account ' || p_from_acc);
    END IF;

    UPDATE Accounts SET Balance = Balance - p_amount WHERE AccountID = p_from_acc;
    UPDATE Accounts SET Balance = Balance + p_amount WHERE AccountID = p_to_acc;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transfer successful.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Test SafeTransferFunds
EXEC SafeTransferFunds(1, 2, 500);   -- should succeed
EXEC SafeTransferFunds(2, 1, 99999); -- should fail: insufficient funds

-- Scenario 2: UpdateSalary - handles non-existent employee
CREATE OR REPLACE PROCEDURE UpdateSalary(
    p_emp_id  NUMBER,
    p_percent NUMBER
) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM Employees WHERE EmployeeID = p_emp_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Employee ID not found: ' || p_emp_id);
    END IF;

    UPDATE Employees
    SET Salary = Salary + (Salary * p_percent / 100)
    WHERE EmployeeID = p_emp_id;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Salary updated for EmployeeID: ' || p_emp_id);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Test UpdateSalary
EXEC UpdateSalary(1, 10);  -- should succeed
EXEC UpdateSalary(99, 10); -- should fail: employee not found

-- Scenario 3: AddNewCustomer - prevents duplicate customer ID
CREATE OR REPLACE PROCEDURE AddNewCustomer(
    p_id      NUMBER,
    p_name    VARCHAR2,
    p_dob     DATE,
    p_balance NUMBER
) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM Customers WHERE CustomerID = p_id;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Customer ID already exists: ' || p_id);
    END IF;

    INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
    VALUES (p_id, p_name, p_dob, p_balance, SYSDATE);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Customer added: ' || p_name);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Test AddNewCustomer
EXEC AddNewCustomer(3, 'Ravi Kumar', TO_DATE('1995-01-01','YYYY-MM-DD'), 5000); -- success
EXEC AddNewCustomer(1, 'Duplicate', SYSDATE, 100); -- should fail: duplicate ID

-- ============================================================
-- EXERCISE 3: STORED PROCEDURES
-- ============================================================

-- Scenario 1: Apply 1% monthly interest to all savings accounts
CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest AS
BEGIN
    UPDATE Accounts
    SET Balance = Balance + (Balance * 0.01),
        LastModified = SYSDATE
    WHERE AccountType = 'Savings';
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Monthly interest applied to all savings accounts.');
END;
/

EXEC ProcessMonthlyInterest;

-- Scenario 2: Add bonus percentage to all employees in a department
CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus(
    p_department VARCHAR2,
    p_bonus_pct  NUMBER
) AS
BEGIN
    UPDATE Employees
    SET Salary = Salary + (Salary * p_bonus_pct / 100)
    WHERE Department = p_department;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Bonus applied to department: ' || p_department);
END;
/

EXEC UpdateEmployeeBonus('IT', 15);

-- Scenario 3: Transfer funds between accounts with balance check
CREATE OR REPLACE PROCEDURE TransferFunds(
    p_from NUMBER,
    p_to   NUMBER,
    p_amt  NUMBER
) AS
    v_bal NUMBER;
BEGIN
    SELECT Balance INTO v_bal FROM Accounts WHERE AccountID = p_from;

    IF v_bal < p_amt THEN
        RAISE_APPLICATION_ERROR(-20004, 'Insufficient balance.');
    END IF;

    UPDATE Accounts SET Balance = Balance - p_amt WHERE AccountID = p_from;
    UPDATE Accounts SET Balance = Balance + p_amt WHERE AccountID = p_to;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transferred $' || p_amt || ' from Account ' || p_from || ' to ' || p_to);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

EXEC TransferFunds(1, 2, 1000);

-- ============================================================
-- EXERCISE 4: FUNCTIONS
-- ============================================================

-- Scenario 1: Calculate customer age from date of birth
CREATE OR REPLACE FUNCTION CalculateAge(p_dob DATE) RETURN NUMBER AS
BEGIN
    RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, p_dob) / 12);
END;
/

-- Test
SELECT Name, CalculateAge(DOB) AS Age FROM Customers;

-- Scenario 2: Calculate EMI (monthly loan installment)
CREATE OR REPLACE FUNCTION CalculateMonthlyInstallment(
    p_loan_amount NUMBER,
    p_rate        NUMBER,  -- annual interest rate in %
    p_years       NUMBER
) RETURN NUMBER AS
    v_monthly_rate NUMBER;
    v_months       NUMBER;
BEGIN
    v_monthly_rate := p_rate / (12 * 100);
    v_months       := p_years * 12;
    RETURN ROUND(
        p_loan_amount * v_monthly_rate * POWER(1 + v_monthly_rate, v_months)
        / (POWER(1 + v_monthly_rate, v_months) - 1), 2
    );
END;
/

-- Test
SELECT CalculateMonthlyInstallment(5000, 5, 5) AS EMI FROM DUAL;

-- Scenario 3: Check if account has sufficient balance
CREATE OR REPLACE FUNCTION HasSufficientBalance(
    p_account_id NUMBER,
    p_amount     NUMBER
) RETURN VARCHAR2 AS
    v_balance NUMBER;
BEGIN
    SELECT Balance INTO v_balance FROM Accounts WHERE AccountID = p_account_id;
    IF v_balance >= p_amount THEN RETURN 'TRUE';
    ELSE RETURN 'FALSE';
    END IF;
END;
/

-- Test
SELECT HasSufficientBalance(1, 500) AS Sufficient FROM DUAL;

-- ============================================================
-- EXERCISE 5: TRIGGERS
-- ============================================================

-- Scenario 1: Auto-update LastModified when customer record changes
CREATE OR REPLACE TRIGGER UpdateCustomerLastModified
BEFORE UPDATE ON Customers
FOR EACH ROW
BEGIN
    :NEW.LastModified := SYSDATE;
END;
/

-- Test
UPDATE Customers SET Balance = 13000 WHERE CustomerID = 1;
SELECT CustomerID, Name, LastModified FROM Customers;

-- Scenario 2: Log every new transaction into AuditLog
CREATE OR REPLACE TRIGGER LogTransaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (TransactionID, AccountID, Amount, TransactionType, LogDate)
    VALUES (:NEW.TransactionID, :NEW.AccountID, :NEW.Amount, :NEW.TransactionType, SYSDATE);
END;
/

-- Test
INSERT INTO Transactions VALUES (3, 1, SYSDATE, 500, 'Deposit');
SELECT * FROM AuditLog;

-- Scenario 3: Block withdrawals exceeding balance and negative deposits
CREATE OR REPLACE TRIGGER CheckTransactionRules
BEFORE INSERT ON Transactions
FOR EACH ROW
DECLARE
    v_balance NUMBER;
BEGIN
    IF :NEW.TransactionType = 'Withdrawal' THEN
        SELECT Balance INTO v_balance FROM Accounts WHERE AccountID = :NEW.AccountID;
        IF v_balance < :NEW.Amount THEN
            RAISE_APPLICATION_ERROR(-20005, 'Withdrawal exceeds account balance.');
        END IF;
    ELSIF :NEW.TransactionType = 'Deposit' AND :NEW.Amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Deposit amount must be positive.');
    END IF;
END;
/

-- Test (should fail - exceeds balance)
INSERT INTO Transactions VALUES (4, 2, SYSDATE, 99999, 'Withdrawal');

-- ============================================================
-- EXERCISE 6: CURSORS
-- ============================================================

-- Scenario 1: Print monthly statement for each customer
DECLARE
    CURSOR GenerateMonthlyStatements IS
        SELECT c.Name, t.TransactionID, t.Amount, t.TransactionType, t.TransactionDate
        FROM Transactions t
        JOIN Accounts a ON t.AccountID = a.AccountID
        JOIN Customers c ON a.CustomerID = c.CustomerID
        WHERE EXTRACT(MONTH FROM t.TransactionDate) = EXTRACT(MONTH FROM SYSDATE)
          AND EXTRACT(YEAR  FROM t.TransactionDate) = EXTRACT(YEAR  FROM SYSDATE);
BEGIN
    FOR rec IN GenerateMonthlyStatements LOOP
        DBMS_OUTPUT.PUT_LINE(
            rec.Name || ' | ' || rec.TransactionType ||
            ' | $' || rec.Amount ||
            ' | ' || TO_CHAR(rec.TransactionDate,'YYYY-MM-DD')
        );
    END LOOP;
END;
/

-- Scenario 2: Deduct annual maintenance fee from all accounts
DECLARE
    CURSOR ApplyAnnualFee IS
        SELECT AccountID FROM Accounts;
    v_fee NUMBER := 100; -- $100 annual fee
BEGIN
    FOR rec IN ApplyAnnualFee LOOP
        UPDATE Accounts
        SET Balance = Balance - v_fee,
            LastModified = SYSDATE
        WHERE AccountID = rec.AccountID;
        DBMS_OUTPUT.PUT_LINE('Annual fee deducted from AccountID: ' || rec.AccountID);
    END LOOP;
    COMMIT;
END;
/

-- Scenario 3: Update loan interest rates based on new policy
DECLARE
    CURSOR UpdateLoanInterestRates IS
        SELECT LoanID, LoanAmount FROM Loans;
    v_new_rate NUMBER;
BEGIN
    FOR rec IN UpdateLoanInterestRates LOOP
        -- Policy: loans > 10000 get 6%, others get 4%
        IF rec.LoanAmount > 10000 THEN v_new_rate := 6;
        ELSE v_new_rate := 4;
        END IF;
        UPDATE Loans SET InterestRate = v_new_rate WHERE LoanID = rec.LoanID;
        DBMS_OUTPUT.PUT_LINE('LoanID ' || rec.LoanID || ' updated to ' || v_new_rate || '%');
    END LOOP;
    COMMIT;
END;
/

-- ============================================================
-- EXERCISE 7: PACKAGES
-- ============================================================

-- Scenario 1: CustomerManagement Package
CREATE OR REPLACE PACKAGE CustomerManagement AS
    PROCEDURE AddCustomer(p_id NUMBER, p_name VARCHAR2, p_dob DATE, p_balance NUMBER);
    PROCEDURE UpdateCustomer(p_id NUMBER, p_name VARCHAR2, p_balance NUMBER);
    FUNCTION  GetBalance(p_id NUMBER) RETURN NUMBER;
END CustomerManagement;
/

CREATE OR REPLACE PACKAGE BODY CustomerManagement AS
    -- Add a new customer
    PROCEDURE AddCustomer(p_id NUMBER, p_name VARCHAR2, p_dob DATE, p_balance NUMBER) AS
    BEGIN
        INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
        VALUES (p_id, p_name, p_dob, p_balance, SYSDATE);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Customer added: ' || p_name);
    END;

    -- Update existing customer name and balance
    PROCEDURE UpdateCustomer(p_id NUMBER, p_name VARCHAR2, p_balance NUMBER) AS
    BEGIN
        UPDATE Customers SET Name = p_name, Balance = p_balance WHERE CustomerID = p_id;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Customer updated: ' || p_id);
    END;

    -- Return customer balance
    FUNCTION GetBalance(p_id NUMBER) RETURN NUMBER AS
        v_bal NUMBER;
    BEGIN
        SELECT Balance INTO v_bal FROM Customers WHERE CustomerID = p_id;
        RETURN v_bal;
    END;
END CustomerManagement;
/

-- Test
EXEC CustomerManagement.AddCustomer(4, 'Test User', TO_DATE('2000-01-01','YYYY-MM-DD'), 3000);
EXEC CustomerManagement.UpdateCustomer(4, 'Test User Updated', 5000);
SELECT CustomerManagement.GetBalance(4) AS Balance FROM DUAL;

-- Scenario 2: EmployeeManagement Package
CREATE OR REPLACE PACKAGE EmployeeManagement AS
    PROCEDURE HireEmployee(p_id NUMBER, p_name VARCHAR2, p_pos VARCHAR2, p_sal NUMBER, p_dept VARCHAR2);
    PROCEDURE UpdateEmployee(p_id NUMBER, p_pos VARCHAR2, p_sal NUMBER);
    FUNCTION  AnnualSalary(p_id NUMBER) RETURN NUMBER;
END EmployeeManagement;
/

CREATE OR REPLACE PACKAGE BODY EmployeeManagement AS
    -- Hire a new employee
    PROCEDURE HireEmployee(p_id NUMBER, p_name VARCHAR2, p_pos VARCHAR2, p_sal NUMBER, p_dept VARCHAR2) AS
    BEGIN
        INSERT INTO Employees VALUES (p_id, p_name, p_pos, p_sal, p_dept, SYSDATE);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Hired: ' || p_name);
    END;

    -- Update employee position and salary
    PROCEDURE UpdateEmployee(p_id NUMBER, p_pos VARCHAR2, p_sal NUMBER) AS
    BEGIN
        UPDATE Employees SET Position = p_pos, Salary = p_sal WHERE EmployeeID = p_id;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Updated EmployeeID: ' || p_id);
    END;

    -- Return annual salary (monthly x 12)
    FUNCTION AnnualSalary(p_id NUMBER) RETURN NUMBER AS
        v_sal NUMBER;
    BEGIN
        SELECT Salary * 12 INTO v_sal FROM Employees WHERE EmployeeID = p_id;
        RETURN v_sal;
    END;
END EmployeeManagement;
/

-- Test
EXEC EmployeeManagement.HireEmployee(3, 'Carol White', 'Analyst', 55000, 'Finance');
EXEC EmployeeManagement.UpdateEmployee(3, 'Senior Analyst', 65000);
SELECT EmployeeManagement.AnnualSalary(1) AS AnnualSalary FROM DUAL;

-- Scenario 3: AccountOperations Package
CREATE OR REPLACE PACKAGE AccountOperations AS
    PROCEDURE OpenAccount(p_acc_id NUMBER, p_cust_id NUMBER, p_type VARCHAR2, p_balance NUMBER);
    PROCEDURE CloseAccount(p_acc_id NUMBER);
    FUNCTION  TotalBalance(p_cust_id NUMBER) RETURN NUMBER;
END AccountOperations;
/

CREATE OR REPLACE PACKAGE BODY AccountOperations AS
    -- Open a new account
    PROCEDURE OpenAccount(p_acc_id NUMBER, p_cust_id NUMBER, p_type VARCHAR2, p_balance NUMBER) AS
    BEGIN
        INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
        VALUES (p_acc_id, p_cust_id, p_type, p_balance, SYSDATE);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Account opened: ' || p_acc_id);
    END;

    -- Close (delete) an account
    PROCEDURE CloseAccount(p_acc_id NUMBER) AS
    BEGIN
        DELETE FROM Accounts WHERE AccountID = p_acc_id;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Account closed: ' || p_acc_id);
    END;

    -- Return total balance across all accounts for a customer
    FUNCTION TotalBalance(p_cust_id NUMBER) RETURN NUMBER AS
        v_total NUMBER;
    BEGIN
        SELECT NVL(SUM(Balance), 0) INTO v_total FROM Accounts WHERE CustomerID = p_cust_id;
        RETURN v_total;
    END;
END AccountOperations;
/

-- Test
EXEC AccountOperations.OpenAccount(3, 1, 'Checking', 2000);
SELECT AccountOperations.TotalBalance(1) AS TotalBalance FROM DUAL;
EXEC AccountOperations.CloseAccount(3);