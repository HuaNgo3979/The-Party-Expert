-- =============================================================================
-- The Party Expert (TPE) — Database Schema
-- Course:  ISYS2038 Database Design & Development (RMIT, Semester A 2025)
-- Author:  Hua Quoc Thinh, Ngo (Williams Ngo)
-- Purpose: Create all tables, keys and integrity constraints for the TPE database.
--
-- Notes:
--   * Reconstructed from the project data dictionary. Verify against your own
--     working .sql file before use.
--   * Run this on an empty schema (e.g. CREATE DATABASE tpe; USE tpe;).
--   * Tables are created in dependency order so the foreign keys resolve.
-- =============================================================================

-- ---------- Core entities (no foreign-key dependencies) ----------------------

CREATE TABLE Client (
    Client_ID       INT             AUTO_INCREMENT PRIMARY KEY,
    C_Surname       VARCHAR(100)    NOT NULL,
    C_Given         VARCHAR(100)    NOT NULL,
    C_Gender        ENUM('Male','Female','Other') NOT NULL,
    C_DOB           DATE            NOT NULL,
    C_Address       VARCHAR(200)    NOT NULL,
    C_Suburb        VARCHAR(100)    NOT NULL,
    C_City          VARCHAR(100)    DEFAULT 'MELBOURNE',
    C_State         VARCHAR(10)     DEFAULT 'VIC',
    C_Postcode      VARCHAR(10)     NOT NULL,
    C_Phone         VARCHAR(20)     UNIQUE,
    C_Email         VARCHAR(100)    UNIQUE NOT NULL,
    Registered_Date DATE            NOT NULL
);

CREATE TABLE Location (
    Location_ID     INT             AUTO_INCREMENT PRIMARY KEY,
    L_Name          VARCHAR(100)    NOT NULL,
    L_Address       VARCHAR(200)    NOT NULL,
    L_Suburb        VARCHAR(100)    NOT NULL,
    L_City          VARCHAR(100)    DEFAULT 'MELBOURNE',
    L_State         VARCHAR(10)     DEFAULT 'VIC',
    L_Postcode      VARCHAR(10)     NOT NULL,
    L_Phone         VARCHAR(20)     UNIQUE,
    L_Email         VARCHAR(100)    UNIQUE NOT NULL,
    Cost            DECIMAL(10,2)   NOT NULL,
    Manager_Name    VARCHAR(100)    NOT NULL
);

CREATE TABLE Employee (
    Employee_ID     INT             AUTO_INCREMENT PRIMARY KEY,
    M_Surname       VARCHAR(100)    NOT NULL,
    M_Given         VARCHAR(100)    NOT NULL,
    M_Gender        ENUM('Male','Female','Other') NOT NULL,
    M_DOB           DATE            NOT NULL,
    M_Address       VARCHAR(200)    NOT NULL,
    M_Suburb        VARCHAR(100)    NOT NULL,
    M_City          VARCHAR(100)    DEFAULT 'MELBOURNE',
    M_State         VARCHAR(10)     DEFAULT 'VIC',
    M_Postcode      VARCHAR(10)     NOT NULL,
    M_Phone         VARCHAR(20)     UNIQUE,
    M_Email         VARCHAR(100)    UNIQUE,
    M_Type          ENUM('Fulltime','Hourly') NOT NULL,
    Hired_Date      DATE            NOT NULL,
    Resigned_Date   DATE            NULL   -- nullable: the Part B trigger checks IS NOT NULL
);

CREATE TABLE Entertainer (
    Entertainer_ID  INT             AUTO_INCREMENT PRIMARY KEY,
    E_Surname       VARCHAR(100)    NOT NULL,
    E_Given         VARCHAR(100)    NOT NULL,
    E_Stage_Name    VARCHAR(100)    NOT NULL,
    Genre           ENUM('Pop','Rock','Classical','HipHop','Funk','Jazz','Other') NOT NULL,
    E_Phone         VARCHAR(20)     UNIQUE,
    E_Email         VARCHAR(100)    UNIQUE NOT NULL,
    Normal_Fee      DECIMAL(10,2)   NOT NULL,
    Experience_Year INT             NOT NULL
);

CREATE TABLE Supplier (
    Supplier_ID     INT             AUTO_INCREMENT PRIMARY KEY,
    Company_Name    VARCHAR(100)    NOT NULL,
    Contact_Name    VARCHAR(100)    NULL,
    S_Address       VARCHAR(200)    NOT NULL,
    S_Suburb        VARCHAR(100)    NOT NULL,
    S_City          VARCHAR(100)    DEFAULT 'MELBOURNE',
    S_State         VARCHAR(10)     DEFAULT 'VIC',
    S_Postcode      VARCHAR(10)     NOT NULL,
    S_Phone         VARCHAR(20)     UNIQUE,
    S_Email         VARCHAR(100)    UNIQUE NOT NULL,
    Rating          INT             NOT NULL CHECK (Rating BETWEEN 1 AND 5)
);

-- ---------- Party (depends on Client, Location, Employee) ---------------------

CREATE TABLE Party (
    Party_ID         INT            AUTO_INCREMENT PRIMARY KEY,
    Client_ID        INT            NOT NULL,
    Location_ID      INT            NOT NULL,
    Lead_Employee_ID INT            NOT NULL,
    Party_Date       DATE           NOT NULL,
    Theme            ENUM('Wedding','Birthday','Special','Corporate','Conference') NOT NULL,
    No_Participant   INT            CHECK (No_Participant > 0),
    Price_Quote      DECIMAL(10,2)  NOT NULL,
    FOREIGN KEY (Client_ID)        REFERENCES Client(Client_ID),
    FOREIGN KEY (Location_ID)      REFERENCES Location(Location_ID),
    FOREIGN KEY (Lead_Employee_ID) REFERENCES Employee(Employee_ID)
);

-- ---------- Invoice (depends on Party) ---------------------------------------

CREATE TABLE Invoice (
    Invoice_ID      INT             AUTO_INCREMENT PRIMARY KEY,
    Party_ID        INT             NOT NULL,
    Invoice_Date    DATE            NOT NULL,
    Invoice_Type    ENUM('Deposit','Final') NOT NULL,
    Payment_Status  ENUM('Paid','Overdue','Pending') NOT NULL,
    Payment_Method  ENUM('Cash','Card','Bank Transfer','Paypal') NOT NULL,
    Amount          DECIMAL(10,2)   NOT NULL,
    FOREIGN KEY (Party_ID) REFERENCES Party(Party_ID)
);

-- ---------- Associative entities (many-to-many resolvers) --------------------

CREATE TABLE Invitation (
    Party_ID        INT             NOT NULL,
    Entertainer_ID  INT             NOT NULL,
    E_Type          ENUM('Band','DJ','MC','Singer') NOT NULL,
    PRIMARY KEY (Party_ID, Entertainer_ID),
    FOREIGN KEY (Party_ID)       REFERENCES Party(Party_ID),
    FOREIGN KEY (Entertainer_ID) REFERENCES Entertainer(Entertainer_ID)
);

CREATE TABLE Responsibility (
    Party_ID        INT             NOT NULL,
    Employee_ID     INT             NOT NULL,
    Hours_Worked    DECIMAL(5,2)    NOT NULL CHECK (Hours_Worked > 0),
    Responsibility  VARCHAR(100)    NOT NULL,
    PRIMARY KEY (Party_ID, Employee_ID),
    FOREIGN KEY (Party_ID)    REFERENCES Party(Party_ID),
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);

CREATE TABLE Purchase (
    Party_ID        INT             NOT NULL,
    Supplier_ID     INT             NOT NULL,
    S_Type          ENUM('Florist','Caterer','Bakery','Party Equipment','Accessory') NOT NULL,
    PRIMARY KEY (Party_ID, Supplier_ID),
    FOREIGN KEY (Party_ID)    REFERENCES Party(Party_ID),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
);

-- =============================================================================
-- Next: load 10–20 test rows per table, then run the queries in this folder.
-- =============================================================================
