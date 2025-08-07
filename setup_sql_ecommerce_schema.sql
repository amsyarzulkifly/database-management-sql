-- ========================================
-- Online Retail Store Database Setup
-- ========================================

-- 1. Create Database
DROP DATABASE IF EXISTS OnlineRetailStore;
CREATE DATABASE OnlineRetailStore;
USE OnlineRetailStore;

-- ========================================
-- 2. Create Tables
-- ========================================

-- Customers
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    JoinDate DATE,
    Country VARCHAR(50)
);

-- Products
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    StockQuantity INT
);

-- Orders
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Order Details
CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- ========================================
-- 3. Insert Sample Data
-- ========================================

-- Customers
INSERT INTO Customers (FirstName, LastName, Email, JoinDate, Country) VALUES
('Ali', 'Khan', 'ali.khan@example.com', '2022-01-10', 'Malaysia'),
('John', 'Doe', 'john.doe@example.com', '2023-03-22', 'USA'),
('Siti', 'Zahra', 'siti.zahra@example.com', '2022-07-14', 'Malaysia'),
('Emily', 'Clark', 'emily.clark@example.com', '2023-01-01', 'UK');

-- Products
INSERT INTO Products (ProductName, Category, Price, StockQuantity) VALUES
('Laptop Pro 14"', 'Electronics', 4500.00, 30),
('Wireless Mouse', 'Accessories', 80.00, 150),
('Office Chair', 'Furniture', 320.00, 20),
('Bluetooth Speaker', 'Electronics', 220.00, 50),
('Notebook', 'Stationery', 10.00, 500);

-- Orders
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2023-08-01', 4580.00),
(2, '2023-08-03', 400.00),
(1, '2023-08-04', 230.00),
(3, '2023-08-05', 90.00),
(4, '2023-08-06', 4800.00);

-- Order Details
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 4500.00),
(1, 2, 1, 80.00),
(2, 3, 1, 320.00),
(2, 2, 1, 80.00),
(3, 4, 1, 220.00),
(3, 5, 1, 10.00),
(4, 2, 1, 80.00),
(5, 1, 1, 4500.00),
(5, 2, 1, 80.00),
(5, 4, 1, 220.00);

-- ========================================
-- 4. Indexes
-- ========================================
CREATE INDEX idx_orders_customerid ON Orders(CustomerID);
CREATE INDEX idx_orderdetails_orderid ON OrderDetails(OrderID);
CREATE INDEX idx_orderdetails_productid ON OrderDetails(ProductID);

-- ========================================
-- 5. Views
-- ========================================

-- View: Customer Orders Summary
CREATE VIEW CustomerOrderSummary AS
SELECT 
    C.CustomerID,
    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
    COUNT(O.OrderID) AS TotalOrders,
    SUM(O.TotalAmount) AS TotalSpent
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID;

-- ========================================
-- 6. Sample Queries (Analytics)
-- ========================================

-- a. Top 3 Customers by Spending
SELECT * FROM CustomerOrderSummary
ORDER BY TotalSpent DESC
LIMIT 3;

-- b. Most Popular Product (by quantity sold)
SELECT 
    P.ProductName,
    SUM(OD.Quantity) AS TotalSold
FROM OrderDetails OD
JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY P.ProductName
ORDER BY TotalSold DESC
LIMIT 1;

-- c. Monthly Revenue
SELECT 
    DATE_FORMAT(OrderDate, '%Y-%m') AS Month,
    SUM(TotalAmount) AS Revenue
FROM Orders
GROUP BY DATE_FORMAT(OrderDate, '%Y-%m');

-- d. Orders with more than 1 item
SELECT 
    OD.OrderID,
    COUNT(*) AS ItemCount
FROM OrderDetails OD
GROUP BY OD.OrderID
HAVING COUNT(*) > 1;

-- e. Window Function: Running Total of Orders
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    TotalAmount,
    SUM(TotalAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS RunningTotal
FROM Orders;

-- f. Subquery: Products never ordered
SELECT * FROM Products
WHERE ProductID NOT IN (
    SELECT DISTINCT ProductID FROM OrderDetails
);

-- g. CTE: Customers who placed orders in August 2023
WITH AugustOrders AS (
    SELECT DISTINCT CustomerID
    FROM Orders
    WHERE OrderDate BETWEEN '2023-08-01' AND '2023-08-31'
)
SELECT C.* 
FROM Customers C
JOIN AugustOrders A ON C.CustomerID = A.CustomerID;

-- h. Join all tables: Full order breakdown
SELECT 
    O.OrderID,
    C.FirstName,
    P.ProductName,
    OD.Quantity,
    OD.UnitPrice,
    (OD.Quantity * OD.UnitPrice) AS LineTotal,
    O.OrderDate
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
JOIN Products P ON OD.ProductID = P.ProductID
ORDER BY O.OrderDate;

-- ========================================
-- Done!
-- ========================================