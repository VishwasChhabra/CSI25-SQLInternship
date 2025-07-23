CREATE TABLE Sales (
    ProductCategory VARCHAR(50),
    ProductName VARCHAR(50),
    SaleAmount DECIMAL(10,2)
);

INSERT INTO Sales (ProductCategory, ProductName, SaleAmount) VALUES
('Electronics', 'Laptop', 1000.00),
('Electronics', 'Phone', 800.00),
('Electronics', 'Tablet', 500.00),
('Clothing', 'Shirt', 300.00),
('Clothing', 'Pants', 400.00),
('Furniture', 'Sofa', 1200.00),
('Furniture', 'Bed', 900.00);


-- Sales Report Generation Using SQL Server ROLLUP
SELECT 
    IFNULL(ProductCategory, 'Total') AS Category,
    IFNULL(ProductName, 'Total') AS Item,
    SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY ProductCategory, ProductName WITH ROLLUP
ORDER BY 
    (ProductCategory IS NULL),
    ProductCategory,
    (ProductName IS NULL),
    ProductName;