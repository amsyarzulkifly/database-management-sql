-- setup_customers.sql

DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    CustomerID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT,
    Age INTEGER,
    City TEXT
);

INSERT INTO Customers (Name, Age, City) VALUES ('Ali', 30, 'Kuala Lumpur');
INSERT INTO Customers (Name, Age, City) VALUES ('Mei Ling', 25, 'Penang');
INSERT INTO Customers (Name, Age, City) VALUES ('Raj', 28, 'Johor Bahru');