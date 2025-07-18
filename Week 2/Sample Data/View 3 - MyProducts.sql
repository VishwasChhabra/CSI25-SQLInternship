CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    CompanyName VARCHAR(100)
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100)
);

ALTER TABLE Products
ADD SupplierID INT, CategoryID INT;

ALTER TABLE Products
ADD CONSTRAINT FK_Products_Suppliers FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID);

ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);

INSERT INTO Suppliers (SupplierID, CompanyName) VALUES
(1, 'Tech Supplies Co'),
(2, 'Gadget Hub Ltd');

INSERT INTO Categories (CategoryID, CategoryName) VALUES
(1, 'Electronics'),
(2, 'Accessories');

UPDATE Products SET SupplierID = 1, CategoryID = 1 WHERE ProductID IN (1, 2);
UPDATE Products SET SupplierID = 2, CategoryID = 2 WHERE ProductID IN (3, 4);

CREATE VIEW MyProducts AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.QuantityPerUnit,
    p.UnitPrice,
    s.CompanyName AS SupplierName,
    c.CategoryName
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.Discontinued = 0;

SELECT * FROM MyProducts;