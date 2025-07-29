-- products_setup.sql

-- Drop table if it exists
DROP TABLE IF EXISTS Products;

-- Create new table
CREATE TABLE Products (
    ProductID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL,
    Category TEXT,
    Price REAL,
    InStock INTEGER  -- 1 = yes, 0 = no
);

-- Insert sample data
INSERT INTO Products (Name, Category, Price, InStock) VALUES ('Laptop', 'Electronics', 3200.00, 1);
INSERT INTO Products (Name, Category, Price, InStock) VALUES ('Smartphone', 'Electronics', 2100.50, 1);
INSERT INTO Products (Name, Category, Price, InStock) VALUES ('Office Chair', 'Furniture', 450.00, 0);
INSERT INTO Products (Name, Category, Price, InStock) VALUES ('Desk Lamp', 'Furniture', 79.90, 1);