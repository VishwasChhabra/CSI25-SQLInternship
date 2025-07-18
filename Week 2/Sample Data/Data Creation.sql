CREATE DATABASE CustomOrderDB;
GO

USE CustomOrderDB;
GO

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    UnitPrice MONEY,
    UnitsInStock INT,
    ReorderLevel INT,
    QuantityPerUnit VARCHAR(50),
    Discontinued BIT DEFAULT 0
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATETIME,
    CompanyName VARCHAR(100)
);

CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    UnitPrice MONEY,
    Quantity INT,
    Discount FLOAT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, UnitPrice, UnitsInStock, ReorderLevel, QuantityPerUnit)
VALUES 
(1, 'Laptop', 55000, 20, 5, '1 Unit'),
(2, 'Smartphone', 25000, 50, 10, '1 Unit'),
(3, 'Headphones', 1500, 100, 20, '1 Unit'),
(4, 'Keyboard', 1000, 10, 5, '1 Unit');

INSERT INTO Orders (OrderID, OrderDate, CompanyName)
VALUES 
(101, '2025-07-02', 'TechWorld Inc'),
(102, '2025-07-03', 'SmartStore Ltd');

INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES 
(101, 1, 55000, 1, 0.05),
(101, 3, 1500, 2, 0.10),
(102, 2, 25000, 2, 0);